pragma solidity ^0.7.3;
import "./BSCAsset.sol";
import "@openzeppelin/contracts/access/Ownable.sol";



contract AssetsFactory is Ownable {

    mapping (uint256 => address) private assets;
    function getAssetsAddress(uint256 assetID) public view returns(address) {
        return assets[assetID];
    }

    function assignAsset(uint256 _assetID, address _to, uint256 _value) onlyOwner public {
        RoobeeAsset(assets[_assetID]).mint(_to, _value);
        emit AssetAssigned(_assetID, _to, _value);
    }


    function issueNewAsset(string memory _name, string memory _symbol, uint256 assetID) onlyOwner public  {
        RoobeeAsset newAsset = new RoobeeAsset(_name, _symbol);
        require(assets[assetID] == address(0), "assetID allready used");
        assets[assetID] = address(newAsset);
        emit AssetIssued(address(newAsset), assetID);
    }

    function burn(uint256 _assetID, uint256 _value, address _from) onlyOwner public {
        RoobeeAsset(assets[_assetID]).burn(_from, _value);
        emit AssetBurned(_assetID, _from, _value);
    }

    /**
    EVENTS
    */
    event AssetIssued(address assetAddress, uint256 assetID);
    event AssetAssigned(uint256 assetID, address to, uint amount);
    event AssetBurned(uint256 assetID, address from, uint amount);

}