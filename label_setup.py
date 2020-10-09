import os
import subprocess
import xml.etree.ElementTree as ET

sets = [('2012', 'train'), ('2012', 'val'),
        ('2007', 'train'), ('2007', 'val'),
        ('2007', 'test')]

max_images = 60000
classes = {
    "person": 0
}


def convert(size, box):
    dw = 1./(size[0])
    dh = 1./(size[1])
    x = (box[0] + box[1])/2.0 - 1
    y = (box[2] + box[3])/2.0 - 1
    w = box[1] - box[0]
    h = box[3] - box[2]
    x = x*dw
    w = w*dw
    y = y*dh
    h = h*dh
    return (x, y, w, h)


def convert_annotation(year, image_id):
    in_file = open(f'VOCdevkit/VOC{year}/Annotations/%{image_id}.xml')
    out_file = open(f'VOCdevkit/VOC{year}/labels/{image_id}.txt', 'w')
    tree = ET.parse(in_file)
    root = tree.getroot()
    size = root.find('size')
    w = int(size.find('width').text)
    h = int(size.find('height').text)
    valid = False

    for obj in root.iter('object'):
        difficult = obj.find('difficult').text
        cls = obj.find('name').text
        if cls not in classes.keys() or difficult == 1:
            continue
        if classes[cls] >= max_images:
            continue
        valid = True
        classes[cls] += 1
        cls_id = list(classes.keys()).index(cls)
        xmlbox = obj.find('bndbox')
        b = (float(xmlbox.find('xmin').text), float(xmlbox.find('xmax').text),
             float(xmlbox.find('ymin').text), float(xmlbox.find('ymax').text))
        bb = convert((w, h), b)
        out_file.write(
            str(cls_id) + " " + " ".join([str(a) for a in bb]) + '\n')
    return valid


wd = os.getcwd()


for year, image_set in sets:
    if not os.path.exists(f'VOCdevkit/VOC{year}/labels/'):
        os.makedirs(f'VOCdevkit/VOC{year}/labels/')
    image_ids = (open(f'VOCdevkit/VOC{year}/ImageSets/Main/{image_set}.txt')
                 .read().strip().split())
    list_file = open(f'{year}_{image_set}.txt', 'w')
    for image_id in image_ids:
        if convert_annotation(year, image_id):
            list_file.write(f'{wd}/VOCdevkit/VOC{year}/JPEGImages/'
                            f'{image_id}.jpg\n')
    list_file.close()
    print(classes)

subprocess.run("cat 2007_train.txt 2007_val.txt 2012_train.txt 2012_val.txt "
               "> train.txt", shell=True)
subprocess.run("cat 2007_train.txt 2007_val.txt 2007_test.txt 2012_train.txt "
               "2012_val.txt > train.all.txt", shell=True)

with open("train.txt", "r") as file:
    print(len(file.readlines()))
with open("2007_test.txt", "r") as file:
    print(len(file.readlines()))
