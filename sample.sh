#!/bin/bash

set -eu

# OpenAI API Key
export OPENAI_API_KEY=""

curdir="$(cd $(dirname $0); pwd)"
image_dest_dirpath="${curdir}/images"

cd "${curdir}"

mkdir -p "${image_dest_dirpath}"

generated_file_name="generated_image.png"
resized_file_name="resized_image.png"
resoluted_file_name="resoluted_image.png"
re_resized_filed_name="re_resized_image.png"

generated_file_path="${image_dest_dirpath}/${generated_file_name}"
resized_file_path="${image_dest_dirpath}/${resized_file_name}"
resoluted_file_path="${image_dest_dirpath}/${resoluted_file_name}"
re_resized_filed_path="${image_dest_dirpath}/${re_resized_filed_name}"

image_width=1024
image_height=1024

resize_width=1024
resize_height=1728

contents_text='『カラフルでキュートなトゥーン猫の世界へようこそ！』 猫好きのための特別な一枚 ここに描かれているのは、まるでアニメから飛び出してきたかのような、鮮やかな色彩と楽しい表情を持つトゥーン猫。この猫はただのキャラクターではありません。それは、冒険心溢れる物語の主人公、いつも私たちを笑顔にしてくれる、愛らしい存在です。'

echo 'Translating...'
image_generate_propmt="$(python3 ./prompt_translate.py "gpt-4-1106-preview" "${contents_text}" "Japanese" "English")"
echo "${image_generate_propmt}"

# Generate PNG image.
echo 'Generating....'
url=$(python3 ./image_generate.py "dall-e-3" "${image_generate_propmt}" "${image_width}" "${image_height}")

echo "Generated image URL: ${url}"

# Download generated image.
echo "Donwloading..."
wget -O "${generated_file_path}" "${url}"
echo "Downloaded file path: ${generated_file_path}"

# Adjust image resolution 
echo "Resoluting..."
python3 ./image_resolution.py "${generated_file_path}" "${resoluted_file_path}" "photo realistic, normal quality, masterpiece, an extremely delicate and beautiful, extremely detailed"
echo "Resoluted file path: ${resoluted_file_path}"

# Resize image
echo "Resizing...."
python3 ./image_resize.py "${resoluted_file_path}" "${resized_file_path}" "${resize_width}" "${resize_height}"
echo "Resized file path: ${resized_file_path}"

exit 0
