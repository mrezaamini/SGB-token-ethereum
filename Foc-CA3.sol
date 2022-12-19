pragma solidity ^0.8.0;

interface IERC20 {
    function name() external view returns (string memory);
	function symbol() external view returns (string memory);
	function decimals() external view returns (uint8);
	function totalSupply() external view returns (uint256);
	function balanceOf(address _owner) external view returns (uint256 balance);
	function transfer(address _to, uint256 _value) external returns (bool success);
	function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
	function approve(address _spender, uint256 _value) external returns (bool success);
	function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract FocSGBtoken is IERC20 {
    using CheckArithmetic for uint256;
    string name_;
    string symbol_;
    uint8 decimals_;
    uint256 totalSupply_;
	uint256 X1;
	uint256 X2;
	uint256 X3;
	uint256 X4;
	uint256 Y;
	address manager;
	uint256 public brick;
	uint256 public concerete;
	uint256 public bloque;
	uint256 public rock;
	
	
	

	mapping ( address => uint256 ) balances;
	mapping ( address => mapping ( address => uint256 )) verified;

	constructor(uint256 _X1,uint256 _X2,uint256 _X3,uint256 _X4,uint256 _Y) {
		X1 = _X1;
		X2 = _X2;
		X3 = _X3;
		X4 = _X4;
		Y = _Y;
		name_ = "SazeGostaranBeheshti";
		symbol_ = "SGB";
		decimals_ = 5;
		totalSupply_ = 0;
		balances[msg.sender] = totalSupply_;
		manager = msg.sender;

	}

	function name() public override view returns (string memory){
		return name_;
	}

	function symbol() public override view returns (string memory){
		return symbol_;
	}

	function decimals() public override view returns (uint8){
		return decimals_;
	}


	function totalSupply() public override view returns (uint256){
		return totalSupply_;
	}

	function addProduction(uint256 _rock,uint256 _concerete,uint256 _bloque,uint256 _brick) public {
		require (msg.sender == manager, "Only chairman can insert new data about production !");
		rock = rock + _rock;
		concerete = _concerete + concerete;
		bloque = bloque + _bloque;
		brick = brick + _brick;
	}

	function balanceOf(address _owner) public override view returns (uint256 balance){
		balance = balances[_owner];
	}

	function transfer(address _to, uint256 _value) public override returns (bool success){ 
		require(msg.sender == manager, "Only chairman can transfer tokens !");
		require (_value <= balances[msg.sender] , "You dont have enough tokens !");
		balances[msg.sender] = balances[msg.sender].sub(_value);
		balances[_to] = balances[_to].add(_value);
		emit Transfer(msg.sender,_to,_value);
		success = true;
	}

	function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success){
		require(msg.sender!=_from, "Use transfer function to transfer from your wallet !");
		require(_value <= balances[_from], "Main address doesnt have enough tokens !");
		require(_value <= verified[_from][msg.sender], "You dont have enough tokens !");
		verified[_from][msg.sender] = verified[_from][msg.sender].sub(_value);
		balances[_from] = balances[_from].sub(_value);
		balances[_to] = balances[_to].add(_value);
		emit Transfer(_from,_to,_value);
		success = true;
	}

	function approve(address _spender, uint256 _value) public override returns (bool success){
		require(msg.sender == manager, "Only chairman can approve new spenders !");
		verified[msg.sender][_spender] = _value;
		emit Approval(msg.sender,_spender,_value);
		success = true;
	}

	function allowance(address _owner, address _spender) public override view returns (uint256 remaining){
		remaining = verified[_owner][_spender];
	}

	function addTokens(uint _value) private returns (bool success){
		totalSupply_ = totalSupply_.add(_value*(10**decimals_));
		success = true;
	}

	function generateTokens() public returns (bool success){
		while ( concerete>=X1 && rock>=X2 && bloque>=X3 && brick>=X4){
			concerete = concerete.sub(X1);
			rock = rock.sub(X2);
			bloque = bloque.sub(X3);
			brick = brick.sub(X4);
			balances[manager] = balances[manager].add(Y*(10**decimals_));
			success = addTokens(Y);
		}
	}

}

library CheckArithmetic{
	function add(uint256 first, uint256 second) internal pure returns (uint256 sum){
		sum = first + second;
		assert (sum >= first);
		assert (sum >= second);
	}

	function sub(uint256 first, uint256 second) internal pure returns (uint256 minus){
		assert (second <= first);
		minus = first - second;
	}

}
