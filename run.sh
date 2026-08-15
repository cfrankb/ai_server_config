#!/bin/bash

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./bin
export PORT=8080

if [ "$1" = "Qwen3-14B-Q6_K" ]; then

koboldcpp Qwen3-14B-Q6_K.gguf --gpulayers 40 --contextsize 32768 --flashattention --quantkv 1

elif [ "$1" = "DeepSeek" ]; then

koboldcpp DeepSeek-V2-Lite-Chat-Q5_K_S.gguf --gpulayers 27 --contextsize 16384 --flashattention \
        --quantkv 1 \
        --jinjatools \
        --threads 4 \
        --useswa \
        --blasbatchsize 512 \
        --threads 4 \
        --no-mmap \
        --usecublas

elif [ "$1" = "gpt" ]; then

koboldcpp \
      --contextsize 24576 \
      --flashattention \
      --blasbatchsize 256 \
      --threads 4 \
      --no-mmap \
      --autofit \
      --quantkv 1 \
      --usecublas \
      --jinja \
      gpt-oss-20b-Q8_0.gguf
      
elif [ "$1" = "mistral7" ]; then
        
koboldcpp \
      --contextsize 24576 \
      --flashattention \
      --blasbatchsize 512 \
      --threads 4 \
      --no-mmap \
      --autofit \
      --quantkv 1 \
      --usecublas \
      --jinja \
      Mistral-7B-Instruct-v0.3-Q8_0.gguf

elif [ "$1" = "mistral12" ]; then
        
koboldcpp \
      --contextsize 24576 \
      --flashattention \
      --blasbatchsize 512 \
      --threads 4 \
      --no-mmap \
      --autofit \
      --quantkv 1 \
      --usecublas \
      --jinja \
      Mistral-Nemo-Instruct-2407-Q8_0.gguf      
      

elif [ "$1" = "Ternary-Bonsai-27B-Q2_0" ]; then
# https://huggingface.co/prism-ml/Ternary-Bonsai-27B-gguf/tree/main
# Ternary-Bonsai-27B-mmproj-
# need it's own fork
# 40t/s

LD_LIBRARY_PATH=:./bin-prism:$LD_LIBRARY_PATH ./bin-prism/llama-server \
  -m prism-ml/Ternary-Bonsai-27B/Ternary-Bonsai-27B-Q2_0.gguf \
  --model-draft prism-ml/Ternary-Bonsai-27B/Ternary-Bonsai-27B-dspark-Q4_1.gguf \
  --spec-type draft-dspark \
  --spec-draft-n-max 4 \
  -ngl 99 \
  -c 32768 \
  --cache-type-k q8_0 \
  --cache-type-v q8_0 \
  --flash-attn on \
  --host 0.0.0.0 \
  --port 5001
  #-b 1024 \
  #-ub 512 \
#  -np 1 \
  
elif [ "$1" = "Bonsai-27B-Q1_0" ]; then
# 50t/s

./bin/llama-server \
  -m lmstudio-community/Bonsai-27B-GGUF/Bonsai-27B-Q1_0.gguf \
  --mmproj lmstudio-community/Bonsai-27B-GGUF/mmproj-Bonsai-27B-BF16.gguf \
  -c 16384 \
    -np 1 \
  --port 5001 \
  --flash-attn on \
  -ngl 99 \
  --cache-type-k q8_0 \
  --cache-type-v q8_0
  # Note: Do NOT use --model-draft for autocomplete; it adds latency.     
  

elif [ "$1" = "gemma-4-26B-A4B-NVFP4" ]; then
  
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./bin ./bin/llama-server \
  --model Gemma4-26b-NVFP4Q8.gguf \
  -ngl 28 \
  --ctx-size 32768 \
  --port 5001 \
  --flash-attn on \
  --cache-type-k q8_0 \
  --cache-type-v q8_0
 

 
elif [ "$1" = "Qwen3.6-35B-A3B" ]; then

./bin/llama-server \
  -m  Qwen3.6-35B-A3B-uncensored-heretic-IQ2_M_HQ.gguf \
  --n-cpu-moe 32 \
  --flash-attn on \
  --no-mmap \
  --jinja \
  -c 65536 \
  -t 8 \
  -b 512 \
  -ub 1024 \
  --cache-type-k q8_0 \
  --cache-type-v q8_0 \
  -np 1 \
  --host 0.0.0.0 \
  --port 5001

#  -m "Qwen3.6-35B-A3B-uncensored-heretic-IQ2_M.gguf" \
#   -ub 128 \
#  -ngl 99 \

elif [ "$1" = "laguna-s-2.1-MXFP4_MOE" ]; then
# Running a 118B Model on 12GB VRAM. Better Qwen 35B?
# https://www.youtube.com/watch?v=NIxCj-3fFNk
./bin/llama-server \
  --model laguna-s-2.1-MXFP4_MOE.gguf \
  --host 127.0.0.1 \
  --port 5001 \
  --fit-target 1500 \
  --ctx-size 65536 \
  --fit on \
  --no-mmap \
  --mlock \
  --cache-type-k q8_0 \
  --cache-type-v q8_0 \
  --threads 8 \
  --special \
  --flash-attn on \
  --n-gpu-layers auto \
  --temp 0.1 \
  --top-p 0.9 \
  -b 512 
 

elif [ "$1" = "laguna-xs2-Q4_K_M" ]; then
#https://huggingface.co/poolside/Laguna-XS-2.1-GGUF
# 50-55t/s

./bin/llama-server \
  --model poolside/Laguna-XS-2.1-GGUF/Laguna-XS-2.1-Q4_K_M.gguf \
   -np 1 \
  --host 127.0.0.1 \
  --port 5001 \
  --fit-target 1500 \
  --ctx-size 65536 \
  --fit on \
  --no-mmap \
  --mlock \
  --cache-type-k q8_0 \
  --cache-type-v q8_0 \
  --threads 8 \
  --special \
  --flash-attn on \
  --n-gpu-layers auto \
  --jinja \
  --temp 0.1 \
  --top-p 0.9 \
  -b 512 

elif [ "$1" = "laguna-xs2-Q4_K_M_draft" ]; then
#https://huggingface.co/poolside/Laguna-XS-2.1-GGUF
#draft:
#https://huggingface.co/RespectMathias/Laguna-XS-2.1-DSpark-GGUF
#45t/s
LD_LIBRARY_PATH=:./bin-rm:$LD_LIBRARY_PATH    ./bin-rm/llama-server \
  --model        poolside/Laguna-XS-2.1-GGUF/Laguna-XS-2.1-Q4_K_M.gguf  \
  --model-draft  poolside/Laguna-XS-2.1-GGUF/Laguna-XS-2.1-DSpark-Q8_0.gguf \
  --spec-type draft-dspark \
  -np 1 \
  --host 127.0.0.1 \
  --port 5001 \
  --fit-target 1500 \
  --ctx-size 32768 \
  --fit on \
  --no-mmap \
  --mlock \
  --cache-type-k q8_0 \
  --cache-type-v q8_0 \
  --threads 8 \
  --special \
  --flash-attn on \
  --n-gpu-layers auto \
  --jinja \
  -b 512 \
    --temp 0.1 \
  --top-p 0.9 \
  --spec-draft-n-max 2


elif [ "$1" = "KAT-Coder-V2.5-Dev-Compact" ]; then
#79t/s
# https://huggingface.co/mudler/KAT-Coder-V2.5-Dev-APEX-GGUF/tree/main
./bin/llama-server -m KAT-Coder-V2.5-Dev-APEX-I-Compact.gguf \
  --fit on \
    -c 65536 \
    --cache-type-k q8_0 \
    --cache-type-v q8_0 \
    --flash-attn on \
    --no-mmap \
    --mlock \
    --jinja \
    --host 0.0.0.0 \
    --port 5001

elif [ "$1" = "KAT-Coder-V2.5-Dev-Mini" ]; then
# 107t/s
# https://huggingface.co/mudler/KAT-Coder-V2.5-Dev-APEX-GGUF/tree/main
./bin/llama-server -m KAT-Coder-V2.5-Dev-APEX-I-Mini.gguf \
  --fit on \
    -c 65536 \
    --cache-type-k q8_0 \
    --cache-type-v q8_0 \
    --flash-attn on \
    --no-mmap \
    --mlock \
    --jinja \
    --temp 0.1 \
    --top-p 0.9 \
    --host 0.0.0.0 \
    --port 5001
    
    
    
    

elif [ "$1" = "gemma-4-26B-A4B-it-UD-IQ4_NL" ]; then
# this is the newest gemma-4
# https://www.reddit.com/r/unsloth/comments/1uz0twj/google_gemma_4_now_runs_faster_with_more_accuracy/
# https://huggingface.co/unsloth/gemma-4-26B-A4B-it-GGUF/tree/main
# mmproj-F16.gguf
# max 30 layers
# 55t/s
# 50t/s

./bin/llama-server \
  --model unsloth/gemma-4-26B-A4B-it/gemma-4-26B-A4B-it-UD-IQ4_NL.gguf \
  --model-draft unsloth/gemma-4-26B-A4B-it/mtp-gemma-4-26B-A4B-it.gguf \
  --spec-draft-n-max 4 \
  --spec-type draft-mtp \
  -np 1 \
  -c 65536 \
  --cache-type-k q8_0 \
  --cache-type-v q8_0 \
  --flash-attn on \
  --kv-unified \
  --jinja \
  --host 0.0.0.0 \
  --port 5001 \
  --load-mode mmap \
  --fit off \
  -ngl 34 \
  --n-cpu-moe 4 \
  --threads 6

exit 0
./bin/llama-server \
  --model unsloth/gemma-4-26B-A4B-it/gemma-4-26B-A4B-it-UD-IQ4_NL.gguf \
  --model-draft unsloth/gemma-4-26B-A4B-it/mtp-gemma-4-26B-A4B-it.gguf \
  --spec-draft-n-max 4 \
  --spec-type draft-mtp \
  --fit off \
  -ngl 30 \
  --ctx-size 65536 \
  --port 5001 \
  --flash-attn on \
  --cache-type-k q8_0 \
  --cache-type-v q8_0 \
   --kv-unified \
  --jinja \
  --parallel 1 \
  --host 0.0.0.0 \
  --no-mmap \
  --n-cpu-moe 4

elif [ "$1" = "grug-27b-Q4_K_M" ]; then
#mmproj-grug-27b-f16.gguf
#https://huggingface.co/ProCreations/grug-27b-gguf/tree/main
#https://huggingface.co/ProCreations/grug-27b-mtp-gguf/tree/main
#https://huggingface.co/mradermacher/grug-27b-mtp-i1-GGUF/tree/main
# 33t/s
./bin/llama-server \
    -m mradermacher/grug-27b-mtp-i1-GGUF/grug-27b-mtp.i1-IQ3_M.gguf \
    --spec-type draft-mtp \
    --spec-draft-n-max 2 \
    -np 1 \
    -c 32768 \
    --temp 0.6 \
    --top-p 0.95 \
    --top-k 20 \
    --cache-type-k q8_0 \
    --cache-type-v q8_0 \
    --port 5001 \
    --host 0.0.0.0 \
    --kv-unified \
    --jinja \
    --flash-attn on \
    -b 1024 \
    -ub 512 \
    --fit on \
    --fit-target 250


elif [ "$1" = "ornith-1.0-35b-Q4_K_M" ]; then
# https://huggingface.co/unsloth/Ornith-1.0-35B-GGUF/tree/main
# mmproj-BF16.gguf
# imatrix_unsloth.gguf_file (useless)
#    --mmproj unsloth/Ornith-1.0-35B/mmproj-BF16.gguf \
# 88t/s
./bin/llama-server \
    -m unsloth/Ornith-1.0-35B/Ornith-1.0-35B-UD-IQ3_XXS.gguf \
    --mmproj unsloth/Ornith-1.0-35B/mmproj-BF16.gguf \
    -np 1 \
    -c 65536 \
    --temp 0.6 \
    --top-p 0.95 \
    --top-k 20 \
    --cache-type-k q8_0 \
    --cache-type-v q8_0 \
    --port 5001 \
    --host 0.0.0.0 \
    --cors-origins localhost \
    --kv-unified \
    --jinja \
    --flash-attn on \
    --load-mode mmap \
    -b 2048 \
    -ub 512 \
    --cache-reuse 256 \
    --keep 4096 \
    --fit on \
    --fit-target 250


elif [ "$1" = "gpt-oss-20b-UD-Q8_K_XL" ]; then
bin/llama-server -m gpt-oss-20b-UD-Q8_K_XL.gguf \
  --ctx-size 32768 \
  --jinja \
  --flash-attn on \
  --cache-type-k q8_0 \
  --cache-type-v q8_0 \
  --batch-size 2048 \
  --ubatch-size 2048 \
  --port 5001 \
   --fit on \
  --temp 1.0 \
  --top-p 1.0 \
  --top-k 20 \
  --min-p 0.0 \
  --no-mmap \
  --chat-template-kwargs '{"reasoning_effort": "high"}'

elif [ "$1" = "Muse-Glimmer-30B-UD-IQ3_XXS" ]; then
# https://huggingface.co/unsloth/Muse-Glimmer-30B-GGUF/tree/main
# with 32gb add mmproj- 
# 40 to 45 tokens per second 
bin/llama-server \
  -m unsloth/Muse-Glimmer-30B/Muse-Glimmer-30B-UD-IQ3_XXS.gguf \
  --model-draft unsloth/Muse-Glimmer-30B/dflash-kquant.gguf \
  --spec-type draft-dflash \
  --spec-draft-n-max 2 \
  -c 65536 \
  --cache-type-k q8_0 \
  --cache-type-v q8_0 \
  --flash-attn on \
  --cors-origins localhost \
  --host 0.0.0.0 \
  --load-mode mmap \
  --threads 6 \
  --cpu-range 0-5 \
  --cpu-strict 1\
  -b 2048 \
  -ub 512 \
  --fit on \
  --fit-target 400 \
  --port 5001
  
elif [ "$1" = "NVIDIA-Nemotron-3.5-Lightning-30B-A3B.iQ4_XS" ]; then
bin/llama-server \
  -m NVIDIA-Nemotron-3.5-Lightning-30B-A3B-IQ4_XS.gguf \
 --fit on \
  -c 24576 \
    --temp 0.6 \
    --top-p 0.95 \
    --top-k 20 \
  --flash-attn on \
  --cache-type-k q8_0 \
  --cache-type-v q8_0 \
  -t 8 \
  -b 2048 \
  -ub 512 \
  --jinja \
  --no-mmap \
  --mlock \
  --port 5001

elif [ "$1" = "Qwen3.8-27B-UD-IQ3_XXS" ]; then
# https://huggingface.co/unsloth/Qwen3.8-27B-GGUF/tree/main
#Qwen3.8-27B-UD-IQ3_XXS.gguf
#Qwen3.8-27B-UD-Q3_K_XL.gguf
# mmproj-BF16.gguf
# 40t/s
bin/llama-server \
    -m unsloth/Qwen3.8/Qwen3.8-27B-UD-IQ3_XXS.gguf \
    --flash-attn on \
    -c 32768 \
    --jinja \
    -t 5 \
    -b 2048 \
    -ub 1024 \
    --cache-type-k q8_0 \
    --cache-type-v q8_0 \
    --spec-type draft-mtp \
    --spec-draft-n-max 2 \
    --n-gpu-layers 99 \
    --fit on \
    --fit-target 150 \
    --port 5001 \
    --host 0.0.0.0
 
else
    echo "No match for $1"   
fi
