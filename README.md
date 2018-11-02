# bod-18-01-terraform :cloud: :zap: #

[![Build Status](https://travis-ci.com/dhs-ncats/bod-18-01-terraform.svg?branch=develop)](https://travis-ci.com/dhs-ncats/bod-18-01-terraform)

`bod-18-01-terraform` contains the Terraform code to build the AWS
infrastructure used for running BOD 18-01 Trustworthy Email scans.
This code utilizes
[`trustymail`](https://github.com/dhs-ncats/trustymail),
[`trustymail-lambda`](https://github.com/dhs-ncats/trustymail-lambda),
[`sslyze`](https://github.com/nabla-c0d3/sslyze), and
[`sslyze-lambda`](https://github.com/dhs-ncats/sslyze-lambda).

## Installation of the Terraform infrastructure ##

```bash
terraform init
terraform apply -var-file=<your_workspace>.tfvars
```

The `apply` command forces you to type `yes` at a prompt before
actually deploying any infrastructure, so it is quite safe to use.  If
you want an extra layer of safety you can opt to use this command when
you just want to validate your Terraform syntax:
```bash
terraform validate -var-file=<your_workspace>.tfvars
```

If you want to see what Terraform *would* deploy if you ran the
`apply` command, you can use this command:
```bash
terraform plan -var-file=<your_workspace>.tfvars
```

## License ##

This project is in the worldwide [public domain](LICENSE.md).

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain
dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.
