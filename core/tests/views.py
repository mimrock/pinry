from django.test import TestCase

from core.models import Image
from core.tests import create_user, reverse
from tests.image_factory import image_file
from users.models import User


__all__ = ['CreateImageTest', 'TestDocs']


class CreateImageTest(TestCase):
    def setUp(self):
        self.user = create_user("default")
        self.client.login(username=self.user.username, password='password')

    def tearDown(self):
        User.objects.all().delete()
        Image.objects.all().delete()

    def test_post(self):
        response = self.client.post(reverse('image-list'), {'image': image_file()})
        image = Image.objects.latest('pk')
        self.assertEqual(response.json()['id'], image.pk)

    def test_post_error(self):
        response = self.client.post(reverse('image-list'), {'image': ''})
        self.assertEqual(
            response.json(),
            {
                'image': [
                    'The submitted data was not a file. '
                    'Check the encoding type on the form.'
                ]
            }
        )


class TestDocs(TestCase):
    def test_should_doc_api_available_without_error(self):
        response = self.client.get("/api/v2/docs/")
        self.assertEqual(response.status_code, 200)

    def test_should_openapi_schema_be_available(self):
        response = self.client.get("/api/v2/schema/?format=json")
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.json()['openapi'].startswith('3.'))
