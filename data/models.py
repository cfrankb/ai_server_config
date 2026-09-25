import json
import requests
from datetime import datetime

# curl -X GET "https://openrouter.ai/api/v1/models" > models.json


def process_local_models_json(input_file_path, output_file):

    if input_file_path:
        # Step 1: Open and read your downloaded JSON file
        try:
            with open(input_file_path, "r", encoding="utf-8") as file:
                payload = json.load(file)
        except FileNotFoundError:
            print(f"Error: The file '{input_file_path}' was not found. Check your file path.")
        except json.JSONDecodeError:
            print("Error: The file contains invalid JSON data.")
        
    else:
        url = "https://openrouter.ai/api/v1/models"
        response = requests.get(url)
        if response.status_code == 200:
            payload = response.json()
            # Save the remote JSON to a local, datetime-stamped file
            json_file = datetime.now().strftime("models_%Y%m%d_%H%M%S.json")
            with open(json_file, "w", encoding="utf-8") as jf:
                json.dump(payload, jf, indent=2, ensure_ascii=False)
            print(f"Saved remote JSON to {json_file}")
        else:
            print(f"Error: Status code {response.status_code}")
            return False

    # Step 2: Grab the 'data' array where OpenRouter stores the models
    models_list = payload.get("data", [])

    # Sort by name
    models_list.sort(key=lambda m: m.get("name", "Unknown Model"))


    print(f"Loaded {len(models_list)} models from local file:\n")
    print(f"{'DISPLAY NAME':<50} | {'API ID (SLUG)'}")
    print("-" * 100)

    with open(output_file, 'w') as t:
        a = list([
            'model_name', 'model_id', 'is_free', 'input', 'output'
        ])
        t.write('\t'.join(a))
        t.write('\n')

        # Step 3: Loop and print the specific key strings
        for model in models_list:
            model_name = model.get("name", "Unknown Model")
            model_id = model.get("id", "Unknown ID")
            
            #print(f"{model_name:<50} | {model_id}")
                    # Extract the nested pricing block
            pricing = model.get("pricing", {})
            
            # Read the individual token costs (defaulting to "0" if missing)
            raw_prompt = pricing.get("prompt", "0")
            raw_completion = pricing.get("completion", "0")
            
            # Convert single-token string fractions into floats and scale to 1 Million tokens
            #p#rompt_cost_1m = float(raw_prompt[0]) * 1,000,000
            #completion_cost_1m = float(raw_completion[0]) * 1,000,000

            #print(raw_prompt)
            #print(type(prompt_cost_1m))
            #print(prompt_cost_1m)
            
            # Determine if it's a completely free tier model
            cost_string = f"Input: ${raw_prompt}/1M | Output: ${raw_completion}"
            is_free = False
            if float(raw_prompt) == 0 and float(raw_completion) == 0:
                is_free = "FREE"
                cost_string = "$0.00"
            else:
                is_free = "PAID"
                cost_string = f"Input: ${raw_prompt} | Output: ${raw_completion}"
                
            print(f"Name: {model_name} | ID: {model_id} | Type: {is_free} | Cost: {cost_string}")

            a = list([
                model_name, model_id, is_free, raw_prompt, raw_completion
            ])
            t.write('\t'.join(a))
            t.write('\n')

            #completion_cost_1m = float(raw_completion) * 1,000,000
                

# Run the parser (Assume your downloaded file is named 'openrouter_models.json')
if __name__ == "__main__":
    #process_local_models_json("models.json",'models260731.tsv')
    output_file = datetime.now().strftime("models_%Y%m%d_%H%M%S.tsv")
    process_local_models_json(None, output_file)
