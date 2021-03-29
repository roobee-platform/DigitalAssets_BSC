pragma solidity ^0.7.3;
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RoobeeAsset is Ownable, IERC20 {
    using SafeMath for uint;

    string private _name;
    string private _symbol;
    uint private  _totalSupply;
    mapping(address => uint) private balances;
    mapping(address => mapping(address => uint)) public _allowances;


     constructor(string memory name_, string memory symbol_) public {
         _name = name_;
         _symbol = symbol_;
    }

    function name() public view  returns (string memory) {
        return _name;
    }
    function symbol() public view  returns (string memory) {
        return _symbol;
    }

    function decimals() public view  returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }


    function balanceOf(address _owner) override public view returns(uint) {
        return balances[_owner];
    }

    function _transfer(address from, address to, uint value) private {
        require(balances[from] >= value, 'ERC20Token: INSUFFICIENT_BALANCE');
        balances[from] = balances[from].sub(value);
        balances[to] = balances[to].add(value);
        if (to == address(0)) { // burn
            _totalSupply = _totalSupply.sub(value);
        }
        emit Transfer(from, to, value);
    }

    function approve(address spender, uint value) override external returns (bool) {
        _allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transfer(address to, uint value) override external returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint value) override external returns (bool) {
        require(_allowances[from][msg.sender] >= value, 'ERC20Token: INSUFFICIENT_ALLOWANCE');
        _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
        _transfer(from, to, value);
        return true;
    }


    function mint(address to, uint256 value) onlyOwner external {
        _totalSupply = _totalSupply.add(value);
        balances[to] = balances[to].add(value);
        emit Transfer(address(0), to, value);
    }

    function burn(address from, uint256 value) onlyOwner external {
        balances[from] = balances[from].sub(value);
        _totalSupply = _totalSupply.sub(value);
        emit Transfer(from, address(0), value);
    }


}





