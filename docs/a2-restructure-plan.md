# Plan: Restructure A2.json — 15 words/topic

## Context
A2 currently has `words_per_topic: 24`, which is too high (A1 uses 15). Since content files are still empty, this is a pure structure update: rewrite `A2.json` to use 15 words/topic, scaling up to 80 topics across 8 categories so total words stays at 1,200.

Math: 1,200 ÷ 15 = 80 topics → 8 categories × 10 topics each.

---

## File to change
- `assets/vocabulary_builder/topics/A2.json` (only this file)

---

## New metadata
```json
"metadata": {
  "total_words": 1200,
  "total_topics": 80,
  "words_per_topic": 15,
  "total_categories": 8
}
```

---

## New category & topic structure (8 categories × 10 topics)

### 1. Personal Life and Relationships *(was 8 → 10)*
Add: `"Life Milestones"`, `"Family Traditions"`

Full list:
Describing Personality, Hobbies and Interests, Relationships, Making Friends,
Invitations and Plans, Celebrations and Parties, Morning and Evening Routines,
Personal Hygiene, Life Milestones, Family Traditions

### 2. Food and Shopping *(was 8 → 10)*
Add: `"Local Markets"`, `"Kitchen Essentials"`

Full list:
Cooking Methods, At the Supermarket, Dining Out, Food Preferences,
At the Mall, Electronics and Gadgets, Returning Items, Household Appliances,
Local Markets, Kitchen Essentials

### 3. Travel and Places *(was 9 → 10)*
Add: `"Asking for Directions"`

Full list:
Neighborhoods, Public Transportation, At the Train Station, At the Airport,
Booking Accommodation, At the Hotel, Tourist Attractions, Traveling Abroad,
At the Beach, Asking for Directions

### 4. Work and Education *(was 8 → 10)*
Add: `"Job Applications"`, `"Online Learning"`

Full list:
Job Responsibilities, Workplace Communication, School Activities, Studying and Exams,
Finding an Apartment, Home Repairs, Furniture and Decor, At the Bank,
Job Applications, Online Learning

### 5. Entertainment and Leisure *(was 8 → 10)*
Add: `"Sports and Teams"`, `"Outdoor Activities"`

Full list:
At the Gym, Going to the Movies, Reading and Books, Art and Crafts,
TV Shows and Series, Concerts and Events, Games and Gaming, Saving and Spending,
Sports and Teams, Outdoor Activities

### 6. Health and Technology *(was 9 → 10)*
Add: `"Staying Safe Online"`

Full list:
At the Pharmacy, Healthy Habits, Injuries and Pain, Natural Disasters,
Geography, Email and Messaging, Social Media Basics, Making Appointments,
Using Computers, Staying Safe Online

### 7. Nature and Environment *(new category — 10 topics)*
Weather and Seasons, Animals and Pets, Plants and Gardens, At the Park,
Recycling and Waste, Natural Landscapes, Outdoor Weather Gear, Urban Nature,
Camping and Hiking, Environmental Awareness

### 8. Community and Services *(new category — 10 topics)*
At the Post Office, At the Library, Local Government, Community Events,
Volunteering, Emergency Services, Neighborhood Safety, Public Facilities,
Social Services, Cultural Centers

---

## Verification
- Open category_screen.dart in the running app at A2 level — should now show 8 collapsed sections, each with 10 topic rows
- Metadata pills in the header should read: `80 Days · 8 Topics · 1200 Vocabulary`
- No code changes required; controller dynamically reads from JSON
