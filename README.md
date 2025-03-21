# local-aider
This repo is just an attempt to collect scripts and notes on how one
can enable using [aider](https://aider.chat) with a local reasoning "architect" model (Qwen/QwQ-32B)
and a non-reasoning "editor" model (Qwen/Qwen2.5-Coder-Instruct-32B)
on a single consumer grade GPU (tested on RTX 3090)


## Usage
```console
$ mkdir brainstorming-repo
$ cd brainstorming-repo
$ git init .
$ ./bin/local-model-enablement-wrapper \
    aider \
        --architect --model litellm_proxy/local-qwq-32b \
        --editor-model litellm_proxy/local-qwen25-coder-32b
```

## Customization
Everything in this repo is probably subject to customization. If you
want to reduce the verbosity of the logging you can adjust these
settings:
```console
grep -E '(logRequests|detailed_debug)' -R .
./compose.yml:      host-litellm.py --config /root/litellm.yml --detailed_debug
./config-llamacpp-container.yaml:logRequests: true
```

## Challenges
- The 32B parameter models fit in 24GB vram, but only one at a time,
  solution: [llama-swap](https://github.com/mostlygeek/llama-swap)
- The easiest way to run the models is using llama.cpp's Docker
  image. But llama-swap has a problem stopping the container when
  unloading a model, solution: run llama-swap [inside](env-llama-cpp-swap/Containerfile) llama.cpp's 
  server container.
- `aider` relies on [litellm](https://github.com/BerriAI/litellm) for routing model selection to different
  backends. litellm relies on 'openai/' prefix to indicate OpenAI
  compatible API endpoint. And while `litellm` offer [custom
  prompts](https://web.archive.org/web/20250214140648/https://docs.litellm.ai/docs/completion/prompt_formatting#format-prompt-yourself)
  as well as taking prompts from huggingface config files, there are
  two problems: the former does not have an effect when the prefix is
  `openai/` (I submitted [a
  PR](https://github.com/BerriAI/litellm/pull/9390) to address this
  here) the latter requires a `huggingface/` prefix which
  unfortunately changes the request format to that of huggingface's
  API which is not OpenAI compatible (as far as I can
  tell). Workaround: I use a patched litellm (from the PR) for now.
  

## TODOs
- [ ] Aider currently does not detect max context size
- [ ] litellm proxy does not seem to propagate request interruption

# Demo
TODO: asciinema goes here.
