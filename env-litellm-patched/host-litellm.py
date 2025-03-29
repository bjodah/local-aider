#!/usr/bin/env python
import litellm
import sys

def main():
    litellm.register_prompt_template(
        model='openai/unsloth--QwQ-32B-GGUF',
        roles={
            "user": {
                "pre_message": "<|im_start|>user\n",
                "post_message": "<|im_end|>\n<|im_start|>assistant\n<think>\n"
            },
        }
    )
    litellm.register_prompt_template(
        model='openai/unsloth--Qwen2.5-Coder-32B-Instruct-GGUF',
        roles={
            "user": {
                "pre_message": "<|im_start|>user\n",
                "post_message": "<|im_end|>\n"
            },
        }
    )
    litellm.register_prompt_template(
        model='openai/tabby-qwq-32b-architect',
        roles={
            "user": {
                "pre_message": "<|im_start|>user\n",
                "post_message": "<|im_end|>\n<|im_start|>assistant\n<think>\n"
            },
        }
    )
    litellm.register_prompt_template(
        model='openai/tabby-qwq-32b-editor',
        roles={
            "user": {
                "pre_message": "<|im_start|>user\n",
                "post_message": "<|im_end|>\n<|im_start|>assistant\n<think>\n</think>\n"
            },
        }
    )
    sys.exit(litellm.run_server())

if __name__ == '__main__':
    main()
