set_n_least_used_CUDA_VISIBLE_DEVICES() {
    local n=${1:-"9999"}
    echo "GPU Memory Usage:"
    local FIRST_N_GPU_IDS=$(nvidia-smi --query-gpu=memory.used --format=csv |
        tail -n +2 |
        nl -v 0 |
        tee /dev/tty |
        sort -g -k 2 |
        awk '{print $1}' |
        head -n $n)
    export CUDA_VISIBLE_DEVICES=$(echo $FIRST_N_GPU_IDS | sed 's/ /,/g')
    echo "Now CUDA_VISIBLE_DEVICES is set to:"
    echo "CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES"
}

set_n_least_used_CUDA_VISIBLE_DEVICES 2

# torchrun --standalone --nproc_per_node=2 train_prompts.py prompts.csv --strategy colossalai_zero2

#torchrun --standalone --nproc_per_node=2 train_prompts.py \
#    --pretrain_dataset /path/to/data.json \
#    --prompt_dataset /path/to/data.json \
#    --strategy colossalai_zero2 \
#    --num_episodes 1 --num_collect_steps 2 --num_update_steps 1 \
#    --train_batch_size 2

torchrun --standalone --nproc_per_node=2 train_prompts.py \
    --pretrain "bigscience/bloom-560m" \
    --model 'bloom' \
    --strategy colossalai_zero2 \
    --prompt_dataset dataset/sample.csv \
    --pretrain_dataset InstructionWild/data/instinwild_en.json
