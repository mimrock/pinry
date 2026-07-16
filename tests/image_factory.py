from io import BytesIO

from django.core.files.images import ImageFile
from PIL import Image


def image_bytes(size=(370, 370), image_format="PNG"):
    image = Image.new("RGB", size, color=(35, 121, 160))
    output = BytesIO()
    image.save(output, format=image_format)
    return output.getvalue()


def image_file(name="test.png", size=(370, 370)):
    return ImageFile(BytesIO(image_bytes(size=size)), name=name)


def pil_image(size=(370, 370)):
    return Image.open(BytesIO(image_bytes(size=size)))
