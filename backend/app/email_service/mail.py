from __future__ import print_function
import sib_api_v3_sdk
from sib_api_v3_sdk.rest import ApiException
from pprint import pprint
from jinja2 import Environment, FileSystemLoader, Template

proxies = {
    "http": "http://111.72.196.83:2324"
}

env = Environment(
    loader=FileSystemLoader('templates'),
    autoescape=True,
    trim_blocks=True,
    lstrip_blocks=True
)
configuration = sib_api_v3_sdk.Configuration()
configuration.api_key[
    'api-key'] = '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'
# configuration.proxy = proxies['http']

api_instance = sib_api_v3_sdk.TransactionalEmailsApi(sib_api_v3_sdk.ApiClient(configuration))


def send_letter(first_name, second_name, email, code):
    context = {
        'first_name': first_name,
        'code0': code[0],
        'code1': code[1],
        'code2': code[2],
        'code3': code[3],
        'code4': code[4],
        'code5': code[5]
    }
    template = env.get_template('template.html')
    letter = template.render(context)

    send_smtp_email = sib_api_v3_sdk.SendSmtpEmail(
        sender={"email": "punctualis.team@gmail.com", "name": "Punctualis"},
        to=[{"email": email, "name": first_name + second_name}],
        subject="Код подтверждения | Punctualis",
        html_content=letter,
    )
    try:
        api_response = api_instance.send_transac_email(send_smtp_email)
        pprint(api_response)
    except ApiException as e:
        pass
        # print("Exception when calling TransactionalEmailsApi->send_transac_email: %s\n" % e)
