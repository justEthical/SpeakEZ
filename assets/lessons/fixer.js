#!/usr/bin/env node
const fs = require("fs");
const path = require("path");

// --- args ---
const args = process.argv.slice(2);
if (!args[0]) {
  console.error("Usage: node fixer.js <folder> [--backup] [--dry-run]");
  process.exit(1);
}
const folderPath = args[0];
const BACKUP = args.includes("--backup");
const DRY_RUN = args.includes("--dry-run");

// Remove any "(Audio: ...)" part — handles single/double quotes
const AUDIO_NOTE_REGEX = /\(Audio:\s*["'][\s\S]*?["']\)/gi;

function cleanQuestion(text) {
  if (!text || typeof text !== "string") return text;
  return text.replace(AUDIO_NOTE_REGEX, "").trim();
}

function processFile(filePath) {
  const src = fs.readFileSync(filePath, "utf8");
  let json;
  try {
    json = JSON.parse(src);
  } catch (e) {
    console.error(`❌ Failed to parse JSON: ${filePath} -> ${e.message}`);
    return { changed: false, count: 0 };
  }

  const listening = json?.question_pools?.listening;
  if (!Array.isArray(listening)) {
    return { changed: false, count: 0 };
  }

  let changes = 0;
  for (const item of listening) {
    if (item && typeof item.question === "string") {
      const before = item.question;
      const after = cleanQuestion(before);
      if (before !== after) {
        item.question = after;
        changes++;
      }
    }
  }

  if (changes > 0 && !DRY_RUN) {
    if (BACKUP) {
      fs.writeFileSync(filePath + ".bak", src, "utf8");
    }
    fs.writeFileSync(filePath, JSON.stringify(json, null, 2) + "\n", "utf8");
  }

  return { changed: changes > 0, count: changes };
}

function main() {
  const files = fs.readdirSync(folderPath).filter(f => f.endsWith(".json"));

  // sort numerically if files are like "12.json"
  files.sort((a, b) => {
    const na = parseInt(a, 10), nb = parseInt(b, 10);
    if (!isNaN(na) && !isNaN(nb)) return na - nb;
    return a.localeCompare(b);
  });

  let total = 0, touched = 0;

  for (const file of files) {
    const fp = path.join(folderPath, file);
    const { changed, count } = processFile(fp);
    if (changed) {
      touched++;
      total += count;
      console.log(`✅ Cleaned ${file} — ${count} question(s) updated${DRY_RUN ? " (dry-run)" : ""}`);
    } else {
      console.log(`➖ No changes in ${file}`);
    }
  }

  console.log(`\nDone. Files changed: ${touched}/${files.length}. Questions updated: ${total}.${DRY_RUN ? " (dry-run only, nothing written)" : ""}`);
}

main();
