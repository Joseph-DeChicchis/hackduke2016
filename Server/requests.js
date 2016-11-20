var Client = require('coinbase').Client;

var client = new Client({
  'apiKey': 'xN5h9TfOKmS6GB4o',
  'apiSecret': 'xwPMH9BBG1sxx9uWYwAsZS3AxnxioxtF',
});

//Create a new wallet for a project
function createAcct(project_name){
	var id;

	client.createAccount({'name': project_name}, function(err, acct) {
  		console.log(acct.name + ' ' + acct.id);
  		id = acct.id;
	});
	return id;
}

//Delete a wallet after a project is over or canceled
function delAcct(id){
	client.getAccount(id, function(err, acct) {
    	acct.delete(function(err, resp) {});
	});
}

//Function to get balance (in BTC)
function getBalance(id){
	var balance;
	
	client.getAccount(id, function(err, acct) {
    	console.log(acct.balance.amount);
    	balance = acct.balance.amount;
	});
	return balance;
}

//Function to get balance (in USD)
function getBalanceN(id){
	var balance;
	
	client.getAccount(id, function(err, acct) {
   		console.log(acct.native_balance.amount);
   		balance = acct.native_balance.amount;
	});
	return balance;
}

//Function to get time wallet was created
function getStart(id){
	var time;
	client.getAccount(id, function(err, acct) {
   		console.log(acct.created_at);
   		time = acct.created_at;
	});
	return time;
}

//Send money from our account to a user 
function sendBit(acct_id,to_address,amount){
	client.getAccount(acct_id,function(err, acct) {
		acct.sendMoney({'to': to_address,
                     'amount': amount,
                     'currency': 'BTC'}, 
                     function(err, tx) {
  		});
	});
}

//Request money from a given email address
function requestBit(acct_id,email,amount){
	client.getAccount(acct_id,function(err, acct) {
		acct.requestMoney({'to': email,
                        'amount': amount,
                        'currency': 'BTC'}, function(err, tx) {
  		});
	});
}


//createAcct('testName');
var testId = '453b2933-ee48-58c2-a9ac-1520e864fa29';
// var testEmail = '';
// var testAMT = .1;
//console.log(getStart(testId));
// console.log(getBalance(testId));
// console.log(getBalanceN(testId));
//requestBit(testId,testEmail,testAMT);
delAcct(testId);
