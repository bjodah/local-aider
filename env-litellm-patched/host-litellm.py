#!/usr/bin/env python
import litellm
import sys

def main():
    litellm.register_prompt_template(
        model='openai/unsloth--QwQ-32B-GGUF',
        roles={
            "user": {
                "pre_message": "user\n",
                "post_message": "\nassistant\n<think>"
            },
        }
    )
    litellm.register_prompt_template(
        model='openai/unsloth--Qwen2.5-Coder-32B-Instruct-GGUF',
        roles={
            "user": {
                "pre_message": "user\n",
                "post_message": "\n"
            },
        }
    )
    print(f"{litellm.custom_prompt_dict=}") # Spurious debug print statement, TODO: remove this.
    sys.exit(litellm.run_server())

if __name__ == '__main__':
    main()
