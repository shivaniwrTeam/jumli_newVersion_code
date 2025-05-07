import os
import re

def refactor_custom_text(directory):
    # Define regex patterns for methods and their replacements
    methods = {
        r'\.underline\(\)': 'showUnderline: true',  # Converts `.underline()` to `showUnderline: true`
        r'\.color\((.*?)\)': r'color: \1',          # Converts `.color(...)` to `color: ...`
        r'\.size\((.*?)\)': r'fontSize: \1',        # Converts `.size(...)` to `fontSize: ...`
        r'\.bold\(\)': 'fontWeight: FontWeight.bold',  # Converts `.bold()` to `fontWeight: FontWeight.bold`
        r'\.italic\(\)': 'fontStyle: FontStyle.italic', # Converts `.italic()` to `fontStyle: FontStyle.italic`
    }

    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(".dart"):
                file_path = os.path.join(root, file)
                print(f"Processing file: {file_path}")  # Debug

                with open(file_path, 'r') as f:
                    content = f.read()

                original_content = content

                # Match `CustomText` instances with chained methods
                pattern = r'CustomText\((.*?)(\)\..*?);'
                matches = re.finditer(pattern, content, re.DOTALL)

                for match in matches:
                    custom_text_args = match.group(1)  # Arguments inside CustomText()
                    chained_methods = match.group(2)  # Chained methods

                    # Process chained methods
                    additional_args = []
                    for method_pattern, replacement in methods.items():
                        match_found = re.search(method_pattern, chained_methods)
                        if match_found:
                            # Apply replacements and collect arguments
                            additional_args.append(re.sub(method_pattern, replacement, match_found.group()))
                            chained_methods = re.sub(method_pattern, '', chained_methods)

                    # Construct the new `CustomText` widget
                    new_args = ', '.join([custom_text_args] + additional_args)
                    new_custom_text = f'CustomText({new_args});'
                    content = content.replace(match.group(0), new_custom_text)

                # Write changes if content was modified
                if content != original_content:
                    with open(file_path, 'w') as f:
                        f.write(content)
                    print(f"Refactored file: {file_path}")
                else:
                    print(f"No changes made to {file_path}")

# Set the directory containing your Dart project
dart_project_dir = "/Users/vanshimehta/Documents/Hetvi/tasks/eClassify/lib/ui/screens/blogs"
refactor_custom_text(dart_project_dir)
