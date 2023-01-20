#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/ironfish/send.sh)

WALLETS="
  36a7b7f5fa9c93cd0cfadc01bed9f67758810b1019b3f73824e4c7e722e22861
  a805214c1a35da6c07eddb194512a914089fed975fd587e68d3184528c9f5a39
  6bf84d6bd73d4f3fa0ce1d413605ddb40acf04fadea4b612b5dc741a0b3d3c45
  04863ca67d9af35f842e205f87272becf3b1797ed437b80a1a97759f16a1bf46
  97179e6dce4842f0b0b521e917cd01202fc8bdabd18b8ff7946a2b9026207723
  b59695938ac25c9d0c6c97f8cf94506deba470674198b83466b9307bdaa93b29
  1455bdfa00c2d26f1919db1863fa1cff775f8f85e20b80cc421b4018d08d13ae
  c94daf2cea64a0e586881a70090f90fc5a302627b93c52c4260f7b1d55556938
  f7891d008f5ea05f594fec9f1fa38f408e2a3e0e57bd48e0c573ab61ebd5b143
  af14097733c76b91fb32f58cc73082d4c7b33f6baa10b9a0557364b43fc8cb9d
  8c49233fe72a7e728e7e8ea7c773d08e9117dcd2180cdd5fed8d7dba1f71c2de
  b028ab545bf1e74002bac849b262344c0cc88dee75d52a053342689b997fae23
  49f1823327e1cf7c28252c415d050586e6d68a4e0797214bc7d8c59883e2ee18
  4e8b2377cd325ed532c1cb81d0f2eadb83a8fc1c0d5c98e351acd2209da3854e
  e14417720a33f11ea427ef96f503adc2f53b06fd7f1a6579a877ad453b8e6eee
  f356f7ee19cef3eb1c7818d2742238d4c44007d8a67691a24d8850fff697b73d
  b028ab545bf1e74002bac849b262344c0cc88dee75d52a053342689b997fae23
  ff16609bd490f3abe9f56748c113006c04512035993d08c28406ffd96dfb0013
  fec51df88bad47323dcacbed7e514107b30081082e2b12072f309d161aaaeb86
  11d510cbf2be7c6fc84e1efb86514145cfac103cb755b9ee84c00becf53a2634
  382c9c4035e596ab5351b33068698bdef495f2de6358d5fa6c1c01fb80412521
  29707dfc38a6592c65519bd1fce715d30a928e840e266f55e180d53a6cacc222
  541db5efa5adb35db23d9283d30eaafb210699874348af7b428284b2551df8b0
  a6c1fae21ab51e380f8edd746ca7bff35352734e5b0e8c77592b18597292e629
  5a8d2eee76d8f919c88ddea2cc0199db44ccbed55b6591830ddc2d2150d96906
  3190a49a432649b5e1a5fb7eeaf802edd44330354879b3037b19d0bcf689d02f
  8031fce05c5f590b000d4fae1bc8a3a333c9cf1845df23b2c9c024d85b1e32a0
  d41af00480d0ee61202d76d28727b9152f008e470b0400b3416dcc1c7b758288
  675ae462b8ec7c7b6f4480e4756ec4335714791dcd445a69e3feafe605e38ace
  c6f5bfb3c330eade42da11ce0898be3bae6f3fafaec8a3229497e5e3c6344747
  40930b40b12fcc75a289fa8977905c58ec4751e1ba06a25467f628345f4b8685
  10336949bab317031f6633dcd9f24c6591b5116233badaf3e47265afcaa27030
  8eabd1316cc1eefb09a234e75ec2f5fe734db9df51ca3a1eb855fd8a3b467cab
  22eace78aff68060697f2b1c6200bafd6655be4ccc93d5d7bcdc693cb99668a0
  d7b79be8d19e3c98ed3d4245f4d4b1e125b2ad636854f250f0c49defde28f6c1
  8e6afdbea19b154e1fe465970cce0c53b864542dc26490f4b92124dd5a69be38
  f48fc54539fb18576be9dd25817a484dcc672ed0a5779d17588607b5475e5c70
  933fd9631989ed258bdccd70bd11ebbdde08d3f7f98e317fac2b8dcc63cd1863
  aa6c2b5c5b64be92715038dbeeeec4cf7b8dae0bcbeaa838d79b9308d900f49f
  fbb220017fa2e142259ddd2fb2f80104af703997444f9ebe1e2e672aa9ea7964
  9887d3faa8d4c813d8fed65cea27770f488c190d589c0316aa4d29dff4028893
  7c27d138e288ff591ed602d3a5be99ddf522f93cb95c5ae925c9748f19b7efda
  c064225b57f49ab410934f768423604e596ab01e5772d38e2356671fc5313243
  da48fcc67411a803e98700ac148cc5a7dbade0cf6e1254ae4ae6539141ebd2d8
  01637d3116767e35174c02b9922c6d0ea5961a993ac37522977555434323f3a6
  5317523a725191ec5b400b860044779ad5c3c16217f244be74ce05ff6257c8eb
  fc86d3825444a5e5d0a7dcbb04ac0bb412a040638ebfd073ee7ae06df6a1c9a9
  a6cba676cc72ab87d26d9ed84bd5b5a35a5fbcb896a2ed2e57317317e5c1c4d8
  688f3527008eb2badd5ec8cea1faa9a7c86482ffedc13557c5da556a5ec4d596
  deb59538b16dd6ec79c194225d611f9e2699514bb76273b799ff353632e80d38
  ae030592a3de020191a97e6d640989c2cd3f2c50aa5523737eeebc280440aa57
  2faf3f65b668d03bf04805b967e39165e474dc975c35292541ab836b3e048c2c
  5e4a1320a43566b6716b2a5eec74572b4948a5de6b8f3d4b32a92af44718be6f
  b6be7c8a4eace3d819744bd0fd6d421cfc3d0f81f7f4c4ff5f86fbb944d31b01
  4af358deb3385a6e3d17afd80777460b1269f522dae4e7482a4a116393e181f2
  59c74b257de409da143d0e2c200504cbe477ca7fb6ac515bac1cc5147986463b
  8d5c467678991850d5f8ed831be7f7ea4da5ad8d5d754ca1ca0b93508a1dc33a
  e54376f0566065ffc27e6e8ef82b3a871e2cdb6e869c246229108f5d1ad0581b
  95f94a8fef706c7c1be6f6696d43be3c7868a14922f6a0e84ebf94004a0a705c
  fe31d86afec96bd6fdfc58fd18d6fe67198c44afed8153661766b234a40a3907
  3c6352e8906d5ae5ee9d988403a042f6c46fc87dd338c9405208965503fd6971
  8e80c7d161d0886645199a62e4bd89d5952884ceec04230d5d9c0cb7d67ccf46
  cbb4a3633721171a9e35af6c02e213140ac4c89100001dd9058043c25e5586ea
  3d100b6c4ad315fc03dcb327ed51b61a57f9028328a7c7387b282b7e126f238e
  d1b4b44b69fa316fa254849694e7a2e2de57b740dcace1d8a216c52564dd9957
  e533bf91e681e78852922562983f57ac534a87fb07a52f02ef5fd32c75838471
  0dc926130d92bdf7aa4cae22e6d85e864dfcb6f8cb72729d3d327b434772fd1b
  c10a76def7f1dd4a4302665224a715e5195bd542c3d0d741cfd5197f5c1c1653
  b82d13631c1c5072c50e8cec8d8fae096156b61fa5290589f367a2c2287362e2
  c683d17966a76963f8f74d73d7fe59b06b9f35bf7ba707360ffd1f79b6e46abb
  "

for WALLET in ${WALLETS} ; do
  docker exec ironfish ./bin/run wallet:send -a 0.025 -f tsibaa -i 4d256fb609bdc07a8233eca2c6639141efaa6749d3db2ddd0ebff453742f7521 -t $WALLET -o 0.001 --confirm
    sleep 300
done


