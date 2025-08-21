#!/usr/bin/env node
/* validate-lessons.js
 * Validate lesson JSON files against your Dart model + business rules.
 * Usage: node validate-lessons.js ./lessons
 */

const fs = require("fs");
const path = require("path");

// Allowed enum values (must match your Dart enum)
const QUESTION_TYPES = new Set([
  "multipleChoice",
  "fillInTheBlanks",
  "trueFalse",
  "sentenceRearranging",
  "listening",
  "speaking",
]);

// Helpers
const isString = (v) => typeof v === "string";
const isObject = (v) => v && typeof v === "object" && !Array.isArray(v);
const isArray = Array.isArray;
const hasKeys = (obj, keys) => keys.every((k) => Object.prototype.hasOwnProperty.call(obj, k));
const inRange = (n, min, max) => Number.isInteger(n) && n >= min && n <= max;
const toArray = (v) => (Array.isArray(v) ? v : []);
const lowerKeys = (obj) =>
  isObject(obj)
    ? Object.fromEntries(Object.entries(obj).map(([k, v]) => [k.toLowerCase(), v]))
    : {};

// Translation check: accept either lower or title case keys; warn if missing either language
function checkQuestionTranslation(q, issues, pathStr) {
  if (q.question_translation == null) {
    issues.push(`${pathStr}: missing question_translation`);
    return;
  }
  if (!isObject(q.question_translation)) {
    issues.push(`${pathStr}: question_translation must be an object`);
    return;
  }
  const t = lowerKeys(q.question_translation);
  if (!t.hindi || !isString(t.hindi)) {
    issues.push(`${pathStr}: question_translation.hindi missing or not a string`);
  }
  if (!t.japanese || !isString(t.japanese)) {
    issues.push(`${pathStr}: question_translation.japanese missing or not a string`);
  }
}

function checkExamples(examples, issues, pathStr) {
  if (!isArray(examples)) {
    issues.push(`${pathStr}: examples must be an array`);
    return;
  }
  examples.forEach((ex, i) => {
    const p = `${pathStr}.examples[${i}]`;
    if (!isObject(ex)) {
      issues.push(`${p}: example must be an object`);
      return;
    }
    if (!isString(ex.sentence)) issues.push(`${p}: sentence missing or not a string`);
    if (ex.translation != null) {
      if (!isObject(ex.translation)) {
        issues.push(`${p}: translation must be an object if provided`);
      } else {
        const t = lowerKeys(ex.translation);
        if (!t.hindi || !isString(t.hindi)) {
          issues.push(`${p}: translation.hindi missing or not a string`);
        }
        if (!t.japanese || !isString(t.japanese)) {
          issues.push(`${p}: translation.japanese missing or not a string`);
        }
      }
    }
  });
}

function checkVocabularyItem(item, issues, pathStr) {
  const req = ["word", "meaning", "examples"];
  req.forEach((k) => {
    if (!item || !isString(item[k]) && k !== "examples") {
      issues.push(`${pathStr}: ${k} missing or wrong type`);
    }
  });
  if (item.word_translation != null && !isObject(item.word_translation)) {
    issues.push(`${pathStr}: word_translation must be an object if provided`);
  }
  if (item.meaning_translation != null && !isObject(item.meaning_translation)) {
    issues.push(`${pathStr}: meaning_translation must be an object if provided`);
  }
  checkExamples(item.examples, issues, pathStr);
}

function checkGrammarTip(tip, issues, pathStr) {
  if (!isString(tip.title)) issues.push(`${pathStr}: title missing or not a string`);
  if (!isString(tip.explanation)) issues.push(`${pathStr}: explanation missing or not a string`);
  if (tip.explanation_translation != null && !isObject(tip.explanation_translation)) {
    issues.push(`${pathStr}: explanation_translation must be an object if provided`);
  }
}

function checkOptionsAndAnswer(q, issues, pathStr) {
  const type = q.type;

  // speaking: no options required, answer should be string
  if (type === "speaking") {
    if (q.options && q.options.length > 0) {
      issues.push(`${pathStr}: speaking should not have options (or keep it empty)`);
    }
    if (typeof q.answer !== "string") {
      issues.push(`${pathStr}: speaking.answer must be a string (expected spoken text)`);
    }
    return;
  }

  // other types must have options
  if (!Array.isArray(q.options) || q.options.length === 0) {
    issues.push(`${pathStr}: options must be a non-empty array for type ${type}`);
    return;
  }

  // true/false: exactly 2 options and answer index 0/1
  if (type === "trueFalse") {
    if (q.options.length !== 2) {
      issues.push(`${pathStr}: trueFalse must have exactly 2 options`);
    }
    if (!(Number.isInteger(q.answer) && (q.answer === 0 || q.answer === 1))) {
      issues.push(`${pathStr}: trueFalse.answer must be 0 or 1`);
    }
    return;
  }

  // sentenceRearranging: answer can be array of indices OR array of strings (permutation of options)
  if (type === "sentenceRearranging") {
    const n = q.options.length;

    const isPermutationOfIndices = (arr) => {
      if (!Array.isArray(arr) || arr.length !== n) return false;
      if (!arr.every(Number.isInteger)) return false;
      const set = new Set(arr);
      if (set.size !== n) return false;
      for (let i = 0; i < n; i++) if (!set.has(i)) return false;
      return true;
    };

    const isPermutationOfStrings = (arr) => {
      if (!Array.isArray(arr) || arr.length !== n) return false;
      if (!arr.every((x) => typeof x === "string")) return false;

      const normalize = (xs) =>
        xs.map((v) => v.toLowerCase().trim())
          .reduce((m, v) => {
            m[v] = (m[v] || 0) + 1;
            return m;
          }, {});

      const a = normalize(arr);
      const b = normalize(q.options);

      const aKeys = Object.keys(a);
      if (aKeys.length !== Object.keys(b).length) return false;

      return aKeys.every((k) => a[k] === b[k]);
    };


    if (!(isPermutationOfIndices(q.answer) || isPermutationOfStrings(q.answer))) {
      issues.push(
        `${pathStr}: sentenceRearranging.answer must be an array of indices (permutation 0..${n - 1}) ` +
        `or an array of strings (permutation of options)`
      );
    }
    return;
  }

  // multipleChoice, fillInTheBlanks, listening: answer should be a valid index
  if (!Number.isInteger(q.answer)) {
    issues.push(`${pathStr}: answer must be an integer index for type ${type}`);
    return;
  }
  if (q.answer < 0 || q.answer >= q.options.length) {
    issues.push(`${pathStr}: answer index ${q.answer} out of range (0..${q.options.length - 1})`);
  }
}


function checkQuestion(q, issues, pathStr) {
  if (!isString(q.id)) issues.push(`${pathStr}: id missing or not a string`);
  if (!isString(q.type) || !QUESTION_TYPES.has(q.type)) {
    issues.push(`${pathStr}: type missing/invalid ("${q.type}")`);
  }
  if (!isString(q.question)) issues.push(`${pathStr}: question missing or not a string`);

  // audio_text rules
  if (q.type === "listening") {
    if (!q.audio_text || !isString(q.audio_text)) {
      issues.push(`${pathStr}: listening question must include audio_text (string)`);
    }
  } else {
    if (q.audio_text != null && !isString(q.audio_text)) {
      issues.push(`${pathStr}: audio_text must be a string if provided`);
    }
  }

  checkQuestionTranslation(q, issues, pathStr);
  checkOptionsAndAnswer(q, issues, pathStr);
}


function validateLesson(obj) {
  const issues = [];

  // Top-level required keys
  ["id", "lesson_name", "purpose", "cefrLevel", "lesson_intro", "question_pools"].forEach(
    (k) => {
      if (!Object.prototype.hasOwnProperty.call(obj, k)) {
        issues.push(`$.${k} missing`);
      }
    }
  );

  // Primitive fields
  if (!isString(obj.id)) issues.push("$.id must be string");
  if (!isString(obj.lesson_name)) issues.push("$.lesson_name must be string");
  if (!isString(obj.purpose)) issues.push("$.purpose must be string");
  if (!isString(obj.cefrLevel)) issues.push("$.cefrLevel must be string");

  // lesson_intro
  if (!isObject(obj.lesson_intro)) {
    issues.push("$.lesson_intro must be object");
  } else {
    const li = obj.lesson_intro;
    if (!isArray(li.vocabulary)) {
      issues.push("$.lesson_intro.vocabulary must be array");
    } else {
      li.vocabulary.forEach((v, i) => checkVocabularyItem(v, issues, `$.lesson_intro.vocabulary[${i}]`));
    }
    if (!isArray(li.grammar_tips)) {
      issues.push("$.lesson_intro.grammar_tips must be array");
    } else {
      li.grammar_tips.forEach((g, i) => checkGrammarTip(g, issues, `$.lesson_intro.grammar_tips[${i}]`));
    }
  }

  // question_pools
  if (!isObject(obj.question_pools)) {
    issues.push("$.question_pools must be object");
  } else {
    const qp = obj.question_pools;
    ["vocabulary", "sentence", "listening", "speaking"].forEach((section) => {
      if (!isArray(qp[section])) {
        issues.push(`$.question_pools.${section} must be array`);
      } else {
        qp[section].forEach((q, i) => checkQuestion(q, issues, `$.question_pools.${section}[${i}]`));
      }
    });
  }

  return issues;
}

function main() {
  const dir = process.argv[2];
  if (!dir) {
    console.error("Usage: node validate-lessons.js <folder>");
    process.exit(2);
  }
  if (!fs.existsSync(dir) || !fs.statSync(dir).isDirectory()) {
    console.error(`Not a directory: ${dir}`);
    process.exit(2);
  }

  const files = fs.readdirSync(dir).filter((f) => f.toLowerCase().endsWith(".json"));
  if (files.length === 0) {
    console.warn("No .json files found.");
    process.exit(0);
  }

  let total = 0;
  let passed = 0;
  let failed = 0;

  for (const file of files) {
    total++;
    const full = path.join(dir, file);
    let data;
    try {
      const raw = fs.readFileSync(full, "utf8");
      data = JSON.parse(raw);
    } catch (e) {
      failed++;
      console.log(`\n❌ ${file} — JSON parse error: ${e.message}`);
      continue;
    }

    const issues = validateLesson(data);
    if (issues.length === 0) {
      passed++;
      console.log(`\n✅ ${file} — OK`);
    } else {
      failed++;
      console.log(`\n❌ ${file} — ${issues.length} issue(s):`);
      issues.forEach((msg, i) => console.log(`  ${i + 1}. ${msg}`));
    }
  }

  console.log("\n──────── Summary ────────");
  console.log(`Total files: ${total}`);
  console.log(`Passed:      ${passed}`);
  console.log(`Failed:      ${failed}`);
  console.log("─────────────────────────");

  process.exit(failed > 0 ? 1 : 0);
}

if (require.main === module) main();
