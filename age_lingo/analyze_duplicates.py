import json
import os

# Load the terms
with open("assets/data/terms.json", "r") as f:
    data = json.load(f)

# Create a dictionary to store terms by their word
terms_by_word = {}
for term in data["terms"]:
    word = term["word"]
    if word not in terms_by_word:
        terms_by_word[word] = []
    terms_by_word[word].append(term)

# Find duplicates
duplicates = {word: terms for word, terms in terms_by_word.items() if len(terms) > 1}

# Print summary
print(f"Found {len(duplicates)} duplicate terms")
print("=" * 50)

# Print detailed information about duplicates
for word, terms in duplicates.items():
    print(f"\nDuplicate term: {word}")
    for i, term in enumerate(terms):
        print(f"  Instance {i+1}:")
        print(f"    Generation: {term['generation']}")
        print(f"    Definition: {term['definition']}")
        print(f"    Example: {term['example']}")
        print(f"    Translations: {term['translations']}") 