#!/usr/bin/env python
import litellm
import sys

def main():
    litellm.register_prompt_template(
        model='openai/cpp-unsloth--QwQ-32B-GGUF',
        roles={
            "user": {
                "pre_message": "<|im_start|>user\n",
                "post_message": "<|im_end|>\n<|im_start|>assistant\n<think>\n"
            },
        }
    )
    litellm.register_prompt_template(
        model='openai/cpp-unsloth--Qwen2.5-Coder-32B-Instruct-GGUF',
        roles={
            "user": {
                "pre_message": "<|im_start|>user\n",
                "post_message": "<|im_end|>\n"
            },
        }
    )
    litellm.register_prompt_template(
        model='openai/exllamav2-bartowski-qwq-32b',
        roles={
            "user": {
                "pre_message": "<|im_start|>user\n",
                "post_message": "<|im_end|>\n<|im_start|>assistant\n<think>\n"
            },
        }
    )
    litellm.register_prompt_template(
        model='openai/exllamav2-bartowski-qwen25-coder-32b',
        roles={
            "user": {
                "pre_message": "<|im_start|>user\n",
                "post_message": "<|im_end|>\n<|im_start|>assistant\n<think>\n</think>\n"
            },
        }
    )
    print(f"{litellm.custom_prompt_dict=}") # debug print statement, can safely be removed.
    sys.exit(litellm.run_server())

if __name__ == '__main__':
    main()
