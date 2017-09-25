pragma solidity ^0.4.5;

import "truffle/Assert.sol";

contract TestFail {

    // addresses for mnemonic "scene kite dust inherit sample upset person below fancy drive mean place"
    address[10] voters = [0x617a638B22c1F9FDE234C148289Cf8516c9F47FF, 0x3CaeEDBb4CEAEE2ff16E115835f79b7a5da7e250, 0x1eb5f605616d941BEa317A9DF61c9677B2e54337, 0x08015CaC790Fb264bD5dfC97877311bAa7845a08, 0xFb6617A52c3fbdA59ba92b5Ec7A46A93dc4585a1, 0xE2CF3EE4b493EF48f311A7d6F7c911a063817F4C, 0x57C33F511eeCe8634927e77bDF9C6881e2e83479, 0x10fc828e67d72a1D0e19004E113b7992d983f34E, 0x8cBC969a11FA9dB1bF69d9C12B26B247Bf438970, 0x7541B5d0268c93d5aBe727c9f55fE693860A5fe4 ];

    function testMsgSenderInVoters() {
        Assert.isTrue(false, 'false != true');
    }
}
