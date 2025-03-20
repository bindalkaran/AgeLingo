#!/usr/bin/env python3
import json
import os
from collections import defaultdict

def load_terms():
    """Load terms from the JSON file."""
    file_path = 'assets/data/terms.json'
    with open(file_path, 'r') as f:
        data = json.load(f)
    return data

def save_terms(terms):
    """Save terms to the JSON file."""
    file_path = 'assets/data/terms.json'
    with open(file_path, 'w') as f:
        json.dump({"terms": terms}, f, indent=2)
    print(f"Saved {len(terms)} terms to {file_path}")

def find_duplicates(terms):
    """Find duplicates based on the 'word' field."""
    term_dict = defaultdict(list)
    for term in terms:
        # Use lowercase for case-insensitive matching
        term_dict[term['word'].lower()].append(term)
    
    # Filter to only terms with duplicates
    duplicates = {word: instances for word, instances in term_dict.items() if len(instances) > 1}
    return duplicates

def merge_duplicates(duplicate_dict):
    """Merge duplicate terms, combining the best information from each instance."""
    merged_terms = []
    
    for word, instances in duplicate_dict.items():
        print(f"Merging {len(instances)} instances of '{word}'")
        
        # Start with the first instance as the base
        base_term = instances[0].copy()
        
        # If there are different generations, prefer in order: Gen Z, Millennials, Gen Alpha, Gen X, Boomers
        generation_priority = {"Gen Z": 5, "Millennials": 4, "Gen Alpha": 3, "Gen X": 2, "Boomers": 1}
        best_gen_instance = max(instances, key=lambda x: generation_priority.get(x.get('generation', ''), 0))
        base_term['generation'] = best_gen_instance['generation']
        
        # Use the longest definition
        best_definition_instance = max(instances, key=lambda x: len(x.get('definition', '')))
        base_term['definition'] = best_definition_instance['definition']
        
        # Combine translations from all instances for completeness
        all_translations = {}
        for instance in instances:
            if 'translations' in instance:
                for gen, translation in instance['translations'].items():
                    # If we already have a translation for this generation, keep the longer one
                    if gen in all_translations:
                        if len(translation) > len(all_translations[gen]):
                            all_translations[gen] = translation
                    else:
                        all_translations[gen] = translation
        base_term['translations'] = all_translations
        
        # Use the most detailed example (longest)
        best_example_instance = max(instances, key=lambda x: len(x.get('example', '')))
        base_term['example'] = best_example_instance['example']
        
        merged_terms.append(base_term)
        
    return merged_terms

def process_terms():
    """Process all terms, merge duplicates, and update the file."""
    data = load_terms()
    terms = data.get('terms', [])
    
    print(f"Loaded {len(terms)} terms")
    
    # Create a dictionary of terms by word (case-insensitive)
    term_dict = defaultdict(list)
    for term in terms:
        term_dict[term['word'].lower()].append(term)
    
    # Identify duplicates
    duplicates = {word: instances for word, instances in term_dict.items() if len(instances) > 1}
    print(f"Found {len(duplicates)} duplicate terms")
    
    # Merge duplicates
    merged_duplicates = merge_duplicates(duplicates)
    
    # Create a new list of terms with merged duplicates
    unique_terms = []
    processed_words = set(word.lower() for word in duplicates.keys())
    
    # Add non-duplicate terms
    for term in terms:
        if term['word'].lower() not in processed_words:
            unique_terms.append(term)
    
    # Add merged duplicates
    unique_terms.extend(merged_duplicates)
    
    # Sort terms alphabetically by word
    unique_terms.sort(key=lambda x: x['word'].lower())
    
    print(f"Reduced from {len(terms)} to {len(unique_terms)} terms")
    
    # Save the updated terms
    save_terms(unique_terms)
    
    return unique_terms

if __name__ == "__main__":
    process_terms() 