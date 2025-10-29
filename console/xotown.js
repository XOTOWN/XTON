// XOTown Console Extensions
// This file adds XOTown-specific denomination helpers to the web3 console

// XOTown denomination conversion functions
// These mirror the standard web3.fromWei/toWei but use XOTN terminology

/**
 * Convert from Woti (base unit) to XOTN units
 * @param {string|number} woti - Amount in Woti
 * @param {string} unit - Target unit (xotn, gwoti, mwoti, kwoti, woti)
 * @returns {string} Converted amount
 */
web3.fromWoti = function(woti, unit) {
    unit = unit ? unit.toLowerCase() : 'xotn';

    var unitMap = {
        'woti':  '1',
        'kwoti': '1000',
        'mwoti': '1000000',
        'gwoti': '1000000000',
        'xotn':  '1000000000000000000'
    };

    if (!unitMap[unit]) {
        throw new Error('Unknown unit: ' + unit + '. Use: woti, kwoti, mwoti, gwoti, xotn');
    }

    return web3.fromWei(woti, 'wei').div(new web3.BigNumber(unitMap[unit])).toString();
};

/**
 * Convert from XOTN units to Woti (base unit)
 * @param {string|number} amount - Amount in specified unit
 * @param {string} unit - Source unit (xotn, gwoti, mwoti, kwoti, woti)
 * @returns {string} Amount in Woti
 */
web3.toWoti = function(amount, unit) {
    unit = unit ? unit.toLowerCase() : 'xotn';

    var unitMap = {
        'woti':  '1',
        'kwoti': '1000',
        'mwoti': '1000000',
        'gwoti': '1000000000',
        'xotn':  '1000000000000000000'
    };

    if (!unitMap[unit]) {
        throw new Error('Unknown unit: ' + unit + '. Use: woti, kwoti, mwoti, gwoti, xotn');
    }

    return new web3.BigNumber(amount).times(new web3.BigNumber(unitMap[unit])).toString();
};

// Convenience aliases for backwards compatibility
web3.fromWei = web3.fromWoti;
web3.toWei = web3.toWoti;

// Add helper functions to check balances in XOTN
web3.eth.getBalanceXOTN = function(address, callback) {
    if (callback) {
        web3.eth.getBalance(address, function(err, result) {
            if (err) {
                callback(err);
            } else {
                callback(null, web3.fromWoti(result, 'xotn'));
            }
        });
    } else {
        var balance = web3.eth.getBalance(address);
        return web3.fromWoti(balance, 'xotn');
    }
};

// XOTown network info
var xotown = {
    networkName: 'XOTown Mainnet',
    chainId: 29090,
    coinSymbol: 'XOTN',
    coinName: 'XOTN Coin',
    totalSupply: '1000000000000', // 1 trillion XOTN
    consensus: 'Clique PoA',
    blockTime: '3 seconds',

    // Denomination info
    denominations: {
        woti:  { value: '1', description: 'Base unit (like Wei)' },
        kwoti: { value: '1,000', description: 'Kilo Woti (10^3)' },
        mwoti: { value: '1,000,000', description: 'Mega Woti (10^6)' },
        gwoti: { value: '1,000,000,000', description: 'Giga Woti (10^9)' },
        xotn:  { value: '1,000,000,000,000,000,000', description: 'XOTN (10^18 Woti)' }
    },

    // Helper to display network info
    info: function() {
        console.log('========================================');
        console.log('XOTown Network Information');
        console.log('========================================');
        console.log('Network Name:', this.networkName);
        console.log('Chain ID:', this.chainId);
        console.log('Coin Symbol:', this.coinSymbol);
        console.log('Coin Name:', this.coinName);
        console.log('Total Supply:', this.totalSupply, 'XOTN');
        console.log('Consensus:', this.consensus);
        console.log('Block Time:', this.blockTime);
        console.log('========================================');
        console.log('Denominations:');
        for (var unit in this.denominations) {
            console.log('  ' + unit + ': ' + this.denominations[unit].value + ' - ' + this.denominations[unit].description);
        }
        console.log('========================================');
    },

    // Helper to check if connected to XOTown network
    isXOTown: function() {
        return eth.chainId() === this.chainId;
    },

    // Quick balance checker
    myBalance: function() {
        var balance = eth.getBalance(eth.accounts[0]);
        console.log('Address:', eth.accounts[0]);
        console.log('Balance:', web3.fromWoti(balance, 'xotn'), 'XOTN');
        console.log('       :', web3.fromWoti(balance, 'gwoti'), 'GWoti');
        console.log('       :', balance.toString(), 'Woti');
        return web3.fromWoti(balance, 'xotn');
    }
};

// Display welcome message
console.log('========================================');
console.log('🚀 Welcome to XOTown Console');
console.log('========================================');
console.log('Type "xotown.info()" for network information');
console.log('Type "xotown.myBalance()" to check your balance');
console.log('');
console.log('Conversion functions:');
console.log('  web3.fromWoti(amount, "xotn")  - Convert Woti to XOTN');
console.log('  web3.toWoti(amount, "xotn")    - Convert XOTN to Woti');
console.log('  web3.fromWoti(amount, "gwoti") - Convert Woti to GWoti');
console.log('');
console.log('Available units: woti, kwoti, mwoti, gwoti, xotn');
console.log('========================================');
