#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/penumbra/update.sh)

bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/penumbra/update_penumbra.sh)
pcli view address
pcli tx delegate 95penumbra --to penumbravalid1ufwmfmtsgfp952z4cnyg9yh9a53642kvq7828vkjjcskdartnqpqzr9zx6
pcli tx delegate 95penumbra --to penumbravalid19jp2gwykhmeekn64snzfl6kvq9dwnqel2vdjcqmtpl5wgfdn6c8q47kn66
pcli tx delegate 95penumbra --to penumbravalid1emegmxe5yr3xuq4fldmj4sjd55wus4hcsey9tc3mzqycuccc65gsqzyq0z
pcli view staked
