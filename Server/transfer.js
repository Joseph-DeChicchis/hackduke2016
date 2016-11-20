var Client = require('coinbase').Client;

var client = new Client({
  'apiKey': 'API KEY',
  'apiSecret': 'API SECRET',
});

// once a user makes the project
function createWallet(walletName) {
	client.createAccount({'name': walletName}, function(err, acct) {
		console.log(acct.id);
	});
}

function request(id, email, amount) {
	client.getAccount(id, function(err, acct) {
	  account.requestMoney({'to': email,
	                        'amount': amount,
	                        'currency': 'BTC'}, function(err, tx) {
	  });
	});
}

function send(id, address, amount) {
	client.getAccount(id, function(err,acct) {
	  account.sendMoney({'to': address,
	                        'amount': amount,
	                        'currency': 'BTC'}, function(err, tx) {
	  });
	});
}