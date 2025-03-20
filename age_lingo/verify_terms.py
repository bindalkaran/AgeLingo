#!/usr/bin/env python3
import json
from collections import defaultdict

def load_terms():
    """Load terms from the JSON file."""
    file_path = 'assets/data/terms.json'
    with open(file_path, 'r') as f:
        data = json.load(f)
    return data

def verify_terms():
    """Check for duplicate terms and verify the total count."""
    data = load_terms()
    terms = data.get('terms', [])
    
    print(f"Total terms: {len(terms)}")
    
    # Check for duplicates (case-insensitive)
    term_dict = defaultdict(list)
    for term in terms:
        term_dict[term['word'].lower()].append(term)
    
    # Find any remaining duplicates
    duplicates = {word: instances for word, instances in term_dict.items() if len(instances) > 1}
    
    if duplicates:
        print(f"Found {len(duplicates)} remaining duplicate terms:")
        for word, instances in duplicates.items():
            print(f"  '{word}' appears {len(instances)} times")
    else:
        print("No duplicate terms found! All terms are unique.")
    
    # Count terms by generation
    generations = defaultdict(int)
    for term in terms:
        generation = term.get('generation', 'Unknown')
        generations[generation] += 1
    
    print("\nTerms by generation:")
    for gen, count in sorted(generations.items()):
        print(f"  {gen}: {count} terms")

if __name__ == "__main__":
    verify_terms() 