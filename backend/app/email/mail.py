from __future__ import print_function
import sib_api_v3_sdk
from sib_api_v3_sdk.rest import ApiException
from pprint import pprint

proxies = {
    "http": "http://111.72.196.83:2324"
}

configuration = sib_api_v3_sdk.Configuration()
configuration.api_key[
    'api-key'] = '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'
configuration.proxy = proxies['http']

api_instance = sib_api_v3_sdk.TransactionalEmailsApi(sib_api_v3_sdk.ApiClient(configuration))
send_smtp_email = sib_api_v3_sdk.SendSmtpEmail(
    sender={"email": "punctualis.team@gmail.com", "name": "Punctualis"},
    to=[{"email": "alexkmv22@gmail.com", "name": "John Doe"}],
    subject="Тест без шаблона",
    html_content="<strong>Пук</strong>",
)
try:
    api_response = api_instance.send_transac_email(send_smtp_email)
    pprint(api_response)
except ApiException as e:
    print("Exception when calling TransactionalEmailsApi->send_transac_email: %s\n" % e)
