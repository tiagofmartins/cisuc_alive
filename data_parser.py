import json
import os
import shutil
import re

from pdf2image import convert_from_path
from PIL import Image

parse_img_width = 1080
contents = []

# Set folder with the input data
name_dir_data = 'data'
script_dir = os.path.dirname(os.path.realpath(__file__))
path_dir_data = os.path.join(script_dir, name_dir_data)
if not os.path.exists(path_dir_data) or not os.path.isdir(path_dir_data):
    raise FileNotFoundError('Input data folder not found. Expected location: {}'.format(path_dir_data))

# Set folder for the output parsed data
name_dir_data_parsed = 'data_parsed'
path_dir_data_parsed = os.path.join(script_dir, name_dir_data_parsed)
if os.path.exists(path_dir_data_parsed) and os.path.isdir(path_dir_data_parsed):
    shutil.rmtree(path_dir_data_parsed)
os.makedirs(path_dir_data_parsed)

# Set path to output json with all data organised
path_output_json = os.path.join(path_dir_data_parsed, 'data.json')
if os.path.exists(path_output_json):
    os.remove(path_output_json)

# For each category folder
for filename1 in os.listdir(path_dir_data):
    dir_category = os.path.join(path_dir_data, filename1)
    if not os.path.isdir(dir_category):
        continue

    # Determine content category
    content_category, content_subcategory = None, None
    if filename1.lower().startswith('pubs_'):
        content_category = 'Publication'
        content_subcategory = filename1[filename1.index('_') + 1:].replace('_', ' ')
    elif filename1.lower() == 'news':
        content_category = 'News'
    elif filename1.lower() == 'events':
        content_category = 'Event'
    else:
        continue

    # For each content folder
    for filename2 in os.listdir(dir_category):
        dir_content = os.path.join(dir_category, filename2)
        if not os.path.isdir(dir_content):
            continue

        # Create folder for parsed data
        dir_content_relative = os.path.relpath(dir_content, path_dir_data)
        print('Parsing content: {}'.format(dir_content_relative))
        dir_parsed_content = os.path.join(path_dir_data_parsed, dir_content_relative)
        os.makedirs(dir_parsed_content)

        # Create an object for current content
        curr_content = {
            'category': content_category,
            'dir': dir_content_relative,
            'num_images': 0
        }
        if content_subcategory != None:
            curr_content[content_subcategory] = content_subcategory

        # Get attributes
        path_file_info = os.path.join(dir_content, 'info.txt')
        if not os.path.exists(path_file_info):
            raise FileNotFoundError('Info file not found. Expected location: {}'.format(path_file_info))
        with open(path_file_info, 'r') as f:
            # lines = f.readlines() # TODO
            lines = f.readlines()
            lines = [re.sub(' +', ' ', line) for line in lines] # Remove repeated spaces
            attribute, value = '', ''
            for line in lines:
                if line.lstrip().startswith('#'):
                    if len(attribute.strip()) > 0 and len(value.strip()) > 0:
                        curr_content[attribute.strip()] = value.strip()
                    attribute = line.lstrip().lstrip('#').strip()
                    value = ''
                else:
                    value += line
            if len(attribute.strip()) > 0 and len(value.strip()) > 0:
                curr_content[attribute.strip()] = value.strip()
            
        # If content is publication
        if content_category.lower() == 'publication':

            # Locate PDF file
            pdfs = sorted([f for f in os.listdir(dir_content) if f.endswith('.pdf')])
            if len(pdfs) == 0:
                raise FileNotFoundError('PDF not found.')
            path_pdf = os.path.join(dir_content, pdfs[0])

            # Convert PDF pages to images
            images = convert_from_path(path_pdf, dpi=300, thread_count=8)
            for count, page in enumerate(images):
                # Resize image
                output_size = (parse_img_width, int(page.size[1] * (parse_img_width / float(page.size[0]))))
                page = page.resize(size=output_size, resample=Image.LANCZOS)

                # Save image
                output_image_filename = 'page_{:04d}.jpg'.format(count + 1)
                page.save(os.path.join(dir_parsed_content, output_image_filename), format='JPEG')

            # Save number of images
            curr_content['num_images'] = str(len(images))

        # If content is not publication
        else:

            # Locate folder with images
            path_dir_images = os.path.join(dir_content, 'images')
            if os.path.exists(path_dir_images) and os.path.isdir(path_dir_images):

                # Create and save light versions of images
                num_images = 0
                for filename3 in os.listdir(path_dir_images):
                    if filename3.endswith(('.png', '.jpg', 'jpeg')):
                        path_image = os.path.join(path_dir_images, filename3)
                        img = Image.open(path_image)
                        if img.size[0] > parse_img_width:
                            new_size = (parse_img_width, int(img.size[1] * (parse_img_width / float(img.size[0]))))
                            img = img.resize(size=new_size, resample=Image.LANCZOS)
                        img.save(os.path.join(dir_parsed_content, filename3))
                        num_images += 1

                # Save number of images
                curr_content['num_images'] = str(num_images)

        # Check if content data is ok
        mandatory_attributes = []
        if curr_content['category'].lower() == 'publication':
            mandatory_attributes = ('title', 'authors', 'year')
            if curr_content['num_images'] == 0:
                raise ValueError('No images provided.')
        elif curr_content['category'].lower() == 'news':
            mandatory_attributes = ('header',)
        elif curr_content['category'].lower() == 'event':
            mandatory_attributes = ('header', 'when', 'where')
        for attr in mandatory_attributes:
            if attr not in curr_content:
                raise ValueError('Mandatory attribute \'{}\' not specified.'.format(attr))
        
        # Add current content to the list
        contents.append(curr_content)

# Save json with all data organised
with open(path_output_json, 'w', encoding='utf8') as f:
    json.dump({'contents': contents}, f, indent=2, ensure_ascii=False)

# Print completion message
print('Done')
