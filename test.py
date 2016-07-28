import dns.resolver
import pprint


def dns_find_apex(domain):
    domain_parts = domain.split('.')
    answers = dns.resolver.query('.'.join(domain_parts), 'SOA')
    pprint.pprint(answers)
    return
    while domain_parts:
        print('ffooo')
        answers = dns.resolver.query('dnspython.org', 'SOA')
        print('.'.join(domain_parts))
        domain_parts.pop(0)


def main():
    dns_find_apex('webilea.ch')


if __name__ == "__main__":
    main()
