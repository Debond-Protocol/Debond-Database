

// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.0;


interface IERC3475 {
    // STRUCTURE 
    /**
     * @dev Values structure of the Metadata
     */
    struct Values { 
        string stringValue;
        uint uintValue;
        address addressValue;
        bool boolValue;
    }
    /**
     * @dev structure allows to define particular bond metadata (ie the values in the class as well as nonce inputs). 
     * @notice 'title' defining the title information,
     * @notice '_type' explaining the data type of the title information added (eg int, bool, address),
     * @notice 'description' explains little description about the information stored in the bond",
     */
    struct Metadata {
        string title;
        string _type;
        string description;
    }
    /**
     * @dev structure that defines the parameters for specific issuance of bonds and amount which are to be transferred/issued/given allowance, etc.
     * @notice this structure is used to streamline the input parameters for functions of this standard with that of other Token standards like ERC20.
     * @classId is the class id of the bond.
     * @nonceId is the nonce id of the given bond class. This param is for distinctions of the issuing conditions of the bond.
     * @amount is the amount of the bond that will be transferred.
     */
    struct Transaction {
        uint256 classId;
        uint256 nonceId;
        uint256 _amount;
    }

    // WRITABLES
    /**
     * @dev allows the transfer of a bond from one address to another (either single or in batches).
     * @param _from is the address of the holder whose balance is about to decrease.
     * @param _to is the address of the recipient whose balance is about to increase.
     * @param _transactions is the object defining {class,nonce and amount of the bonds to be transferred}.
     */
    function transferFrom(address _from, address _to, Transaction[] calldata _transactions) external;
    /**
     * @dev allows the transfer of allowance from one address to another (either single or in batches).
     * @param _from is the address of the holder whose balance about to decrease.
     * @param _to is the address of the recipient whose balance is about to increased.
     * @param _transactions is the object defining {class,nonce and amount of the bonds to be allowed to transferred}.
     */
    function transferAllowanceFrom(address _from, address _to, Transaction[] calldata _transactions) external;
    /**
     * @dev allows issuing of any number of bond types to an address(either single/batched issuance).
     * The calling of this function needs to be restricted to bond issuer contract.
     * @param _to is the address to which the bond will be issued.
     * @param _transactions is the object defining {class,nonce and amount of the bonds to be issued for given whitelisted bond}.
     */
    function issue(address _to, Transaction[] calldata _transactions) external;
    /**
     * @dev allows redemption of any number of bond types from an address.
     * The calling of this function needs to be restricted to bond issuer contract.
     * @param _from is the address _from which the bond will be redeemed.
     * @param _transactions is the object defining {class,nonce and amount of the bonds to be redeemed for given whitelisted bond}.
     */
    function redeem(address _from, Transaction[] calldata _transactions) external;
    
    /**
     * @dev allows the transfer of any number of bond types from an address to another.
     * The calling of this function needs to be restricted to bond issuer contract.
     * @param _from is the address of the holder whose balance about to decrees.
     * @param _transactions is the object defining {class,nonce and amount of the bonds to be redeemed for given whitelisted bond}.
     */
    function burn(address _from, Transaction[] calldata _transactions) external;
    
    /**
     * @dev Allows _spender to withdraw from your account multiple times, up to the amount.
     * @notice If this function is called again, it overwrites the current allowance with amount.
     * @param _spender is the address the caller approve for his bonds.
     * @param _transactions is the object defining {class,nonce and amount of the bonds to be approved for given whitelisted bond}.
     */
    function approve(address _spender, Transaction[] calldata _transactions) external;
    
    /**
     * @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
     * @dev MUST emit the ApprovalForAll event on success.
     * @param _operator Address to add to the set of authorized operators
     * @param _approved "True" if the operator is approved, "False" to revoke approval.
     */
    function setApprovalFor(address _operator, bool _approved) external;
    
    // READABLES 
    
    /**
     * @dev Returns the total supply of the bond in question.
     */
    function totalSupply(uint256 classId, uint256 nonceId) external view returns (uint256);
    
    /**
     * @dev Returns the redeemed supply of the bond in question.
     */
    function redeemedSupply(uint256 classId, uint256 nonceId) external view returns (uint256);
    
    /**
     * @dev Returns the active supply of the bond in question.
     */
    function activeSupply(uint256 classId, uint256 nonceId) external view returns (uint256);
    
    /**
     * @dev Returns the burned supply of the bond in question.
     */
    function burnedSupply(uint256 classId, uint256 nonceId) external view returns (uint256);
    
    /**
     * @dev Returns the balance of the giving bond classId and bond nonce.
     */
    function balanceOf(address _account, uint256 classId, uint256 nonceId) external view returns (uint256);
    
    /**
     * @dev Returns the JSON metadata of the classes.
     * The metadata SHOULD follow a set of structure explained later in eip-3475.md
     * @param metadataId is the index corresponding to the class parameter that you want to return from mapping.
     */
    function classMetadata(uint256 metadataId) external view returns ( Metadata memory);
    
    /**
     * @dev Returns the JSON metadata of the Values of the nonces in the corresponding class.
     * @param classId is the specific classId of which you want to find the metadata of the corresponding nonce.
     * @param metadataId is the index corresponding to the class parameter that you want to return from mapping.
     * @notice The metadata SHOULD follow a set of structure explained later in metadata section.
     */
    function nonceMetadata(uint256 classId, uint256 metadataId) external view returns ( Metadata memory);
    
    /**
     * @dev Returns the values of the given classId.
     * @param classId is the specific classId of which we want to return the parameter.
     * @param metadataId is the index corresponding to the class parameter that you want to return from mapping.
     * the metadata SHOULD follow a set of structures explained in eip-3475.md
     */
    function classValues(uint256 classId, uint256 metadataId) external view returns ( Values memory);
   
    /**
     * @dev Returns the values of given nonceId.
     * @param metadataId index number of structure as explained in the metadata section in EIP-3475.
     * @param classId is the class of bonds for which you determine the nonce.
     * @param nonceId is the nonce for which you return the value struct info.
     * Returns the values object corresponding to the given value.
     */
    function nonceValues(uint256 classId, uint256 nonceId, uint256 metadataId) external view returns ( Values memory);
    
    /**
     * @dev Returns the information about the progress needed to redeem the bond identified by classId and nonceId.
     * @notice Every bond contract can have its own logic concerning the progress definition.
     * @param classId The class of bonds.
     * @param nonceId is the nonce of bonds for finding the progress.
     * Returns progressAchieved is the current progress achieved.
     * Returns progressRemaining is the remaining progress.
     */
    function getProgress(uint256 classId, uint256 nonceId) external view returns (uint256 progressAchieved, uint256 progressRemaining);
   
    /**
     * @notice Returns the amount that spender is still allowed to withdraw from _owner (for given classId and nonceId issuance)
     * @param _owner is the address whose owner allocates some amount to the _spender address.
     * @param classId is the classId of the bond.
     * @param nonceId is the nonce corresponding to the class for which you are approving the spending of total amount of bonds.
     */
    function allowance(address _owner, address _spender, uint256 classId, uint256 nonceId) external view returns (uint256);
    /**
     * @notice Queries the approval status of an operator for bonds (for all classes and nonce issuances of owner).
     * @param _owner is the current holder of the bonds for all classes/nonces.
     * @param _operator is the address with access to the bonds of _owner for transferring. 
     * Returns "true" if the operator is approved, "false" if not.
     */
    function isApprovedFor(address _owner, address _operator) external view returns (bool);

    // EVENTS
    /**
     * @notice MUST trigger when tokens are transferred, including zero value transfers.
     * e.g: 
     emit Transfer(0x2d03B6C79B75eE7aB35298878D05fe36DC1fE8Ef, 0x492Af743654549b12b1B807a9E0e8F397E44236E,0x3d03B6C79B75eE7aB35298878D05fe36DC1fEf, [IERC3475.Transaction(1,14,500)])
    means that operator 0x2d03B6C79B75eE7aB35298878D05fe36DC1fE8Ef wants to transfer 500 bonds of class 1 , Nonce 14 of owner 0x492Af743654549b12b1B807a9E0e8F397E44236E to address  0x3d03B6C79B75eE7aB35298878D05fe36DC1fEf.
     */
    event Transfer(address indexed _operator, address indexed _from, address indexed _to, Transaction[] _transactions);
    /**
     * @notice MUST trigger when tokens are issued
     * @notice Issue MUST trigger when Bonds are issued. This SHOULD not include zero value Issuing.
    * @dev This SHOULD not include zero value issuing.
    * @dev Issue MUST be triggered when the operator (i.e Bank address) contract issues bonds to the given entity.
    eg: emit Issue(_operator, 0x2d03B6C79B75eE7aB35298878D05fe36DC1fE8Ef,[IERC3475.Transaction(1,14,500)]); 
    issue by address(operator) 500 Bonds(nonce14,class 0) to address 0x2d03B6C79B75eE7aB35298878D05fe36DC1fE8Ef.
     */
    event Issue(address indexed _operator, address indexed _to, Transaction[] _transactions);
    /**
     * @notice MUST trigger when tokens are redeemed.
     * @notice Redeem MUST trigger when Bonds are redeemed. This SHOULD not include zero value redemption.
     * eg: emit Redeem(0x2d03B6C79B75eE7aB35298878D05fe36DC1fE8Ef,0x492Af743654549b12b1B807a9E0e8F397E44236E,[IERC3475.Transaction(1,14,500)]);
     * this emit event when 5000 bonds of class 1, nonce 14 owned by address 0x492Af743654549b12b1B807a9E0e8F397E44236E are being redeemed by 0x2d03B6C79B75eE7aB35298878D05fe36DC1fE8Ef.
     */
    event Redeem(address indexed _operator, address indexed _from, Transaction[] _transactions);
    /**
     * @notice MUST trigger when tokens are burned
     * @dev `Burn` MUST trigger when the bonds are being redeemed via staking (or being invalidated) by the bank contract.
     * @dev `Burn` MUST trigger when Bonds are burned. This SHOULD not include zero value burning
     * @notice emit Burn(0x2d03B6C79B75eE7aB35298878D05fe36DC1fE8Ef,0x492Af743654549b12b1B807a9E0e8F397E44236E,[IERC3475.Transaction(1,14,500)]);
     * emits event when 5000 bonds of owner 0x492Af743654549b12b1B807a9E0e8F397E44236E of type (class 1, nonce 14) are burned by operator 0x2d03B6C79B75eE7aB35298878D05fe36DC1fE8Ef.
     */
    event Burn(address indexed _operator, address indexed _from, Transaction[] _transactions);
    /**
     * @dev MUST emit when approval for a second party/operator address to manage all bonds from a classId given for an owner address is enabled or disabled (absence of an event assumes disabled).
     * @dev its emitted when address(_owner) approves the address(_operator) to transfer his bonds.
     * @notice Approval MUST trigger when bond holders are approving an _operator. This SHOULD not include zero value approval. 
     */
    event ApprovalFor(address indexed _owner, address indexed _operator, bool _approved);
}

interface IERC3475EXTENSION {
    // STRUCTURE
    /**
     * @dev Values structure of the Metadata
     */
    struct ValuesExtension {
        string stringValue;
        uint uintValue;
        address addressValue;
        bool boolValue;
        string[] stringArrayValue;
        uint[] uintArrayValue;
        address[] addressArrayValue;
        bool[] boolAraryValue;
    }
    
       /**
     * @dev Returns the values of the given _metadataTitle.
     * the metadata SHOULD follow a set of structures explained in eip-3475.md
     */
    function classValuesFromTitle(uint256 _classId, string memory _metadataTitle) external view returns (ValuesExtension memory);

    /**
     * @dev Returns the values of given _metadataTitle.
     * @param _classId is the class of bonds for which you determine the nonce .
     * @param _nonceId is the nonce for which you return the value struct info
     */
    function nonceValuesFromTitle(uint256 _classId, uint256 _nonceId, string memory _metadataTitle) external view returns (ValuesExtension memory);    
    
      /**
     * @notice MUST trigger when token class is created
     */     
    event classCreated(address indexed _operator, uint256 _classId);  
    event updateClassMetadata(address indexed _operator, uint256 _classId, ValuesExtension[] oldMetedata, ValuesExtension[] newMetedata);  
    event updateNonceMetadata(address indexed _operator, uint256 _classId, uint256 _nonceId, ValuesExtension[] oldMetedata, ValuesExtension[] newMetedata);  
  
}

contract ERC3475 is IERC3475, IERC3475EXTENSION {

    /**
     * @notice this Struct is representing the Nonce properties as an object
     */
    struct Nonce {
        mapping(uint256 => string) _valuesId;
        mapping(string => ValuesExtension) _values;

        // stores the values corresponding to the dates (issuance and maturity date).
        mapping(address => uint256) _balances;
        mapping(address => mapping(address => uint256)) _allowances;

        // supplies of this nonce
        uint256 _activeSupply;
        uint256 _burnedSupply;
        uint256 _redeemedSupply;
    }

    /**
     * @notice this Struct is representing the Class properties as an object
     *         and can be retrieved by the classId
     */
    struct Class {
        mapping(uint256 => string) _valuesId;
        mapping(string => ValuesExtension) _values;
        mapping(uint256 => IERC3475.Metadata) _nonceMetadatas;
        mapping(uint256 => Nonce) _nonces;
    }

    mapping(address => mapping(address => bool)) _operatorApprovals;

    // from classId given
    mapping(uint256 => Class) internal _classes;
    mapping(uint256 => IERC3475.Metadata) _classMetadata;

    /**
     * @notice Here the constructor is just to initialize a class and nonce,
     * in practice, you will have a function to create a new class and nonce
     * to be deployed during the initial deployment cycle
     */
    modifier onlyInternal{
        _;
        require ( msg.sender == address(this));
    }
    constructor() { 
        }
        
    // WRITABLES
    function transferFrom(
        address _from,
        address _to,
        Transaction[] memory _transactions
    ) public virtual override onlyInternal{
        require(
            _from != address(0),
            "ERC3475: can't transfer from the zero address"
        );
        require(
            _to != address(0),
            "ERC3475:use burn() instead"
        );
        require(
            msg.sender == _from ||
            isApprovedFor(_from, msg.sender),
            "ERC3475:caller-not-owner-or-approved"
        );
        uint256 len = _transactions.length;
        for (uint256 i = 0; i < len; i++) {
            _transferFrom(_from, _to, _transactions[i]);
        }
        emit Transfer(msg.sender, _from, _to, _transactions);
    }

    function transferAllowanceFrom(
        address _from,
        address _to,
        Transaction[] memory _transactions
    ) public virtual override onlyInternal{
        require(
            _from != address(0),
            "ERC3475: can't transfer allowed amt from zero address"
        );
        require(
            _to != address(0),
            "ERC3475: use burn() instead"
        );
        uint256 len = _transactions.length;
        for (uint256 i = 0; i < len; i++) {
            require(
                _transactions[i]._amount <= allowance(_from, msg.sender, _transactions[i].classId, _transactions[i].nonceId),
                "ERC3475:caller-not-owner-or-approved"
            );
            _transferAllowanceFrom(msg.sender, _from, _to, _transactions[i]);
        }
        emit Transfer(msg.sender, _from, _to, _transactions);
    }

    function issue(address _to, Transaction[] memory _transactions)
    external
    virtual
    override
    onlyInternal
    {
        uint256 len = _transactions.length;
        for (uint256 i = 0; i < len; i++) {
            require(
                _to != address(0),
                "ERC3475: can't issue to the zero address"
            );
            _issue(_to, _transactions[i]);
        }
        emit Issue(msg.sender, _to, _transactions);
    }

    function redeem(address _from, Transaction[] memory _transactions)
    external
    virtual
    override
    onlyInternal
    {
        require(
            _from != address(0),
            "ERC3475: can't redeem from the zero address"
        );
        uint256 len = _transactions.length;
        for (uint256 i = 0; i < len; i++) {
            (, uint256 progressRemaining) = getProgress(
                _transactions[i].classId,
                _transactions[i].nonceId
            );
            require(
                progressRemaining == 0,
                "ERC3475 Error: Not redeemable"
            );
            _redeem(_from, _transactions[i]);
        }
        emit Redeem(msg.sender, _from, _transactions);
    }

    function burn(address _from, Transaction[] memory _transactions)
    external
    virtual
    override
    onlyInternal
    {
        require(
            _from != address(0),
            "ERC3475: can't burn from the zero address"
        );
        require(
            msg.sender == _from ||
            isApprovedFor(_from, msg.sender),
            "ERC3475: caller-not-owner-or-approved"
        );
        uint256 len = _transactions.length;
        for (uint256 i = 0; i < len; i++) {
            _burn(_from, _transactions[i]);
        }
        emit Burn(msg.sender, _from, _transactions);
    }

    function approve(address _spender, Transaction[] memory _transactions)
    external
    virtual
    override onlyInternal
    {
        for (uint256 i = 0; i < _transactions.length; i++) {
            _classes[_transactions[i].classId]
            ._nonces[_transactions[i].nonceId]
            ._allowances[msg.sender][_spender] = _transactions[i]._amount;
        }
    }

    function setApprovalFor(
        address operator,
        bool approved
    ) public virtual override onlyInternal {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalFor(msg.sender, operator, approved);
    }

    // READABLES
    function totalSupply(uint256 classId, uint256 nonceId)
    public
    view
    override
    returns (uint256)
    {
        return (activeSupply(classId, nonceId) +
        burnedSupply(classId, nonceId) +
        redeemedSupply(classId, nonceId)
        );
    }

    function activeSupply(uint256 classId, uint256 nonceId)
    public
    view
    override
    returns (uint256)
    {
        return _classes[classId]._nonces[nonceId]._activeSupply;
    }

    function burnedSupply(uint256 classId, uint256 nonceId)
    public
    view
    override
    returns (uint256)
    {
        return _classes[classId]._nonces[nonceId]._burnedSupply;
    }

    function redeemedSupply(uint256 classId, uint256 nonceId)
    public
    view
    override
    returns (uint256)
    {
        return _classes[classId]._nonces[nonceId]._redeemedSupply;
    }

    function balanceOf(
        address account,
        uint256 classId,
        uint256 nonceId
    ) public view override returns (uint256) {
        require(
            account != address(0),
            "ERC3475: balance query for the zero address"
        );
        return _classes[classId]._nonces[nonceId]._balances[account];
    }

    function classMetadata(uint256 metadataId)
    external
    view
    override
    returns (Metadata memory) {
        return (_classMetadata[metadataId]);
    }

    function nonceMetadata(uint256 classId, uint256 metadataId)
    external
    view
    override
    returns (Metadata memory) {
        return (_classes[classId]._nonceMetadatas[metadataId]);
    }

    function classValues(uint256 classId, uint256 metadataId)
    external
    view
    override
    returns (Values memory) {
        string memory title = _classes[classId]._valuesId[metadataId];
        Values memory result;
        result.stringValue = _classes[classId]._values[title].stringValue;
        result.uintValue = _classes[classId]._values[title].uintValue;
        result.addressValue = _classes[classId]._values[title].addressValue;
        result.stringValue = _classes[classId]._values[title].stringValue;
        return (result);
    }
     
    function nonceValues(uint256 classId, uint256 nonceId, uint256 metadataId)
    external
    view
    override
    returns (Values memory) {
        string memory title = _classes[classId]._nonces[nonceId]._valuesId[metadataId];
        Values memory result;
        result.stringValue = _classes[classId]._nonces[nonceId]._values[title].stringValue;
        result.uintValue = _classes[classId]._nonces[nonceId]._values[title].uintValue;
        result.addressValue = _classes[classId]._nonces[nonceId]._values[title].addressValue;
        result.stringValue = _classes[classId]._nonces[nonceId]._values[title].stringValue;
        return (result);
    }
    
    function nonceValuesFromTitle(uint256 classId, uint256 nonceId, string memory metadataTitle)
    external
    view
    returns (ValuesExtension memory) {
        return (_classes[classId]._nonces[nonceId]._values[metadataTitle]);
    }  

    function classValuesFromTitle(uint256 classId, string memory metadataTitle)
    external
    view
    returns (ValuesExtension memory) {
        return (_classes[classId]._values[metadataTitle]);
    }  

    /** determines the progress till the  redemption of the bonds is valid  (based on the type of bonds class).
     * @notice ProgressAchieved and `progressRemaining` is abstract.
      For e.g. we are giving time passed and time remaining.
     */
    function getProgress(uint256 classId, uint256 nonceId)
    public
    view
    override
    returns (uint256 progressAchieved, uint256 progressRemaining){
        uint256 issuanceDate = _classes[classId]._nonces[nonceId]._values["issuranceTime"].uintValue;
        uint256 maturityPeriod = _classes[classId]._values["maturityPeriod"].uintValue;

        // check whether the bond is being already initialized:
        progressAchieved = block.timestamp > issuanceDate?        
        block.timestamp - issuanceDate : 0;
        progressRemaining = progressAchieved < maturityPeriod
        ? maturityPeriod - progressAchieved
        : 0;
    }
    /**
    gets the allowance of the bonds identified by (classId,nonceId) held by _owner to be spend by spender.
     */
    function allowance(
        address _owner,
        address spender,
        uint256 classId,
        uint256 nonceId
    ) public view virtual override returns (uint256) {
        return _classes[classId]._nonces[nonceId]._allowances[_owner][spender];
    }

    /**
    checks the status of approval to transfer the ownership of bonds by _owner  to operator.
     */
    function isApprovedFor(
        address _owner,
        address operator
    ) public view virtual override returns (bool) {
        return _operatorApprovals[_owner][operator];
    }

    // INTERNALS
    function _transferFrom(
        address _from,
        address _to,
        IERC3475.Transaction memory _transaction
    ) internal {
        Nonce storage nonce = _classes[_transaction.classId]._nonces[_transaction.nonceId];
        require(
            nonce._balances[_from] >= _transaction._amount,
            "ERC3475: not enough bond to transfer"
        );

        //transfer balance
        nonce._balances[_from] -= _transaction._amount;
        nonce._balances[_to] += _transaction._amount;
    }

    function _transferAllowanceFrom(
        address _operator,
        address _from,
        address _to,
        IERC3475.Transaction memory _transaction
    ) private {
        Nonce storage nonce = _classes[_transaction.classId]._nonces[_transaction.nonceId];
        require(
            nonce._balances[_from] >= _transaction._amount,
            "ERC3475: not allowed _amount"
        );
        // reducing the allowance and decreasing accordingly.
        nonce._allowances[_from][_operator] -= _transaction._amount;

        //transfer balance
        nonce._balances[_from] -= _transaction._amount;
        nonce._balances[_to] += _transaction._amount;
    }

    function _issue(
        address _to,
        IERC3475.Transaction memory _transaction
    ) private {
        Nonce storage nonce = _classes[_transaction.classId]._nonces[_transaction.nonceId];

        //transfer balance
        nonce._balances[_to] += _transaction._amount;
        nonce._activeSupply += _transaction._amount;
    }


    function _redeem(
        address _from,
        IERC3475.Transaction memory _transaction
    ) private {
        Nonce storage nonce = _classes[_transaction.classId]._nonces[_transaction.nonceId];
        // verify whether _amount of bonds to be redeemed  are sufficient available  for the given nonce of the bonds

        require(
            nonce._balances[_from] >= _transaction._amount,
            "ERC3475: not enough bond to transfer"
        );

        //transfer balance
        nonce._balances[_from] -= _transaction._amount;
        nonce._activeSupply -= _transaction._amount;
        nonce._redeemedSupply += _transaction._amount;
    }


    function _burn(
        address _from,
        IERC3475.Transaction memory _transaction
    ) private {
        Nonce storage nonce = _classes[_transaction.classId]._nonces[_transaction.nonceId];
        // verify whether _amount of bonds to be burned are sfficient available for the given nonce of the bonds
        require(
            nonce._balances[_from] >= _transaction._amount,
            "ERC3475: not enough bond to transfer"
        );

        //transfer balance
        nonce._balances[_from] -= _transaction._amount;
        nonce._activeSupply -= _transaction._amount;
        nonce._burnedSupply += _transaction._amount;
    }

}

contract Token is ERC3475 {

    address public publisher;

    address public auctionContract;

    struct Data {
        uint256 onChainDate;
        string warrantNumber;
        uint256 shareValue;
        uint256 claimAmount;
        address claimerChainAddress;
        string[] warrantorDocURL;
    }


    constructor() {
         
        _classes[0]._values["custodianName"].stringValue = "Centrifuge";
        _classes[0]._values["custodianType"].stringValue = "LTD";
        _classes[0]._values["custodianJurisdiction"].stringValue = "BE";
        _classes[0]._values["custodianURL"].stringValue = "https://centrifuge.io";
        _classes[0]._values["custodianLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/centrifuge.jpg";
        _classes[0]._values["coupon"].boolValue = false;   
        _classes[0]._values["fixedMaturity"].boolValue = false;   
        
////////////////////////////////////////////////////////

        _classes[1]._values["symbol"].stringValue = "BlockTower-Series 4 -Senior Loan";
        _classes[1]._values["category"].stringValue = "loan";
        _classes[1]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[1]._values["childCategory"].stringValue = "structured credit";
        
        _classes[1]._values["description"].stringValue = unicode"BlockTower Credit is the credit franchise of BlockTower Capital, an SEC-registered digital asset and blockchain investment firm founded in 2017. Within BlockTower Credit, we apply the skills of professional underwriting, structuring and investing at the intersection of real-world credit (a massive but anachronistic traditional industry) and crypto. This Tinlake Pool deploys capital into Structured Credit products will have an investment-grade rating and typically maintain a weighted average life (WAL) of less than four years. The Structured Credit products will generally fall into three major buckets: consumer ABS, auto ABS, and CLO.";
        _classes[1]._values["issuerName"].stringValue = "BlockTower";
        _classes[1]._values["issuerType"].stringValue = "LTD";
        _classes[1]._values["issuerJurisdiction"].stringValue = "US";
        _classes[1]._values["issuerURL"].stringValue = "https://www.blocktower.com/";
        _classes[1]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Blocktower.png";
        _classes[1]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/BT4.pdf"
        ];
        _classes[1]._values["fundType"].stringValue = "corporate";  
        _classes[1]._values["shareValue"].uintValue = 1;  
        _classes[1]._values["currency"].stringValue = "DAI";  

        _classes[1]._values["maxiumSupply"].uintValue = 1200000;  
        _classes[1]._values["callable"].boolValue = true;  
        _classes[1]._values["coupon"].boolValue = false;   
        _classes[1]._values["fixed-rate"].boolValue = true;  
        _classes[1]._values["APR"].uintValue = 40000;  
        _classes[1]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x55d86d51Ac3bcAB7ab7d2124931FbA106c8b60c7";
        emit classCreated(address(this), 1);

////////////////////////////////////////////////////////

        _classes[2]._values["symbol"].stringValue = "BlockTower-Series 4 -Junior Loan";
        _classes[2]._values["category"].stringValue = "loan";
        _classes[2]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[2]._values["childCategory"].stringValue = "structured credit";
        
        _classes[2]._values["description"].stringValue = unicode"BlockTower Credit is the credit franchise of BlockTower Capital, an SEC-registered digital asset and blockchain investment firm founded in 2017. Within BlockTower Credit, we apply the skills of professional underwriting, structuring and investing at the intersection of real-world credit (a massive but anachronistic traditional industry) and crypto. This Tinlake Pool deploys capital into Structured Credit products will have an investment-grade rating and typically maintain a weighted average life (WAL) of less than four years. The Structured Credit products will generally fall into three major buckets: consumer ABS, auto ABS, and CLO.";
        _classes[2]._values["issuerName"].stringValue = "BlockTower";
        _classes[2]._values["issuerType"].stringValue = "LTD";
        _classes[2]._values["issuerJurisdiction"].stringValue = "US";
        _classes[2]._values["issuerURL"].stringValue = "https://www.blocktower.com/";
        _classes[2]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Blocktower.png";
        _classes[2]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/BT4.pdf"
        ];
        _classes[2]._values["fundType"].stringValue = "corporate";  
        _classes[2]._values["shareValue"].uintValue = 1;  
        _classes[2]._values["currency"].stringValue = "DAI";  

        _classes[2]._values["maxiumSupply"].uintValue = 69700000;  
        _classes[2]._values["callable"].boolValue = true;    
        _classes[2]._values["coupon"].boolValue = false;  
        _classes[2]._values["fixed-rate"].boolValue = false;  
        _classes[2]._values["APR"].uintValue = 40000;  
        _classes[2]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x55d86d51Ac3bcAB7ab7d2124931FbA106c8b60c7";
        emit classCreated(address(this), 2);

////////////////////////////////////////////////////////

        _classes[3]._values["symbol"].stringValue = "BlockTower-Series 3 -Senior Loan";
        _classes[3]._values["category"].stringValue = "loan";
        _classes[3]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[3]._values["childCategory"].stringValue = "structured credit";
        
        _classes[3]._values["description"].stringValue = unicode"BlockTower Credit is the credit franchise of BlockTower Capital, an SEC-registered digital asset and blockchain investment firm founded in 2017. Within BlockTower Credit, we apply the skills of professional underwriting, structuring and investing at the intersection of real-world credit (a massive but anachronistic traditional industry) and crypto. This Tinlake Pool deploys capital into Structured Credit products will have an investment-grade rating and typically maintain a weighted average life (WAL) of less than four years. The Structured Credit products will generally fall into three major buckets: consumer ABS, auto ABS, and CLO.";
        _classes[3]._values["issuerName"].stringValue = "BlockTower";
        _classes[3]._values["issuerType"].stringValue = "LTD";
        _classes[3]._values["issuerJurisdiction"].stringValue = "US";
        _classes[3]._values["issuerURL"].stringValue = "https://www.blocktower.com/";
        _classes[3]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Blocktower.png";
        _classes[3]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/BT3.pdf"
        ];
        _classes[3]._values["fundType"].stringValue = "corporate";  
        _classes[3]._values["shareValue"].uintValue = 1;  
        _classes[3]._values["currency"].stringValue = "DAI";  

        _classes[3]._values["maxiumSupply"].uintValue = 11200000;  
        _classes[3]._values["callable"].boolValue = true;  
        _classes[3]._values["fixed-rate"].boolValue = true;  
        _classes[3]._values["APR"].uintValue = 40000;  
        _classes[3]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x90040F96aB8f291b6d43A8972806e977631aFFdE";
        emit classCreated(address(this), 3);

////////////////////////////////////////////////////////

        _classes[4]._values["symbol"].stringValue = "BlockTower-Series 3 -Junior Loan";
        _classes[4]._values["category"].stringValue = "loan";
        _classes[4]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[4]._values["childCategory"].stringValue = "structured credit";
        
        _classes[4]._values["description"].stringValue = unicode"BlockTower Credit is the credit franchise of BlockTower Capital, an SEC-registered digital asset and blockchain investment firm founded in 2017. Within BlockTower Credit, we apply the skills of professional underwriting, structuring and investing at the intersection of real-world credit (a massive but anachronistic traditional industry) and crypto. This Tinlake Pool deploys capital into Structured Credit products will have an investment-grade rating and typically maintain a weighted average life (WAL) of less than four years. The Structured Credit products will generally fall into three major buckets: consumer ABS, auto ABS, and CLO.";
        _classes[4]._values["issuerName"].stringValue = "BlockTower";
        _classes[4]._values["issuerType"].stringValue = "LTD";
        _classes[4]._values["issuerJurisdiction"].stringValue = "US";
        _classes[4]._values["issuerURL"].stringValue = "https://www.blocktower.com/";
        _classes[4]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Blocktower.png";
        _classes[4]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/BT3.pdf"
        ];
        _classes[4]._values["fundType"].stringValue = "corporate";  
        _classes[4]._values["shareValue"].uintValue = 1;  
        _classes[4]._values["currency"].stringValue = "DAI";  

        _classes[4]._values["maxiumSupply"].uintValue = 19000000;  
        _classes[4]._values["callable"].boolValue = true;   
   
        _classes[4]._values["fixed-rate"].boolValue = false;  
        _classes[4]._values["APR"].uintValue = 40000;  
        _classes[4]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x90040F96aB8f291b6d43A8972806e977631aFFdE";
        emit classCreated(address(this), 4);

////////////////////////////////////////////////////////

        _classes[5]._values["symbol"].stringValue = "Branch-Series 3 (1754 Factory) -Senior Loan";
        _classes[5]._values["category"].stringValue = "loan";
        _classes[5]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[5]._values["childCategory"].stringValue = "emerging market consumer loan";
        
        _classes[5]._values["description"].stringValue = unicode"Branch is a financial technology company that lends money to consumers using machine learning algorithms to determine credit worthiness via customers' smartphones. Branch was founded in 2015 and has operations in Kenya, Nigeria, Tanzania, Mexico and India, and has since originated over $500M in loans to over 4 millions borrowers. This Tinlake pool will consist of tranches of a secured non convertible debenture with a maturity of 3 years backed by a portfolio of loans made to customers.The current weighted average loan balance is $49 (ranging from $6 to $2,500) with average maturity of 70 days.";
        _classes[5]._values["issuerName"].stringValue = "Branch (1754 Factory)";
        _classes[5]._values["issuerType"].stringValue = "LTD";
        _classes[5]._values["issuerJurisdiction"].stringValue = "US";
        _classes[5]._values["issuerURL"].stringValue = "https://www.1754.finance/";
        _classes[5]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Branch.png";
        _classes[5]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/BR3.pdf"
        ];
        _classes[5]._values["fundType"].stringValue = "corporate";  
        _classes[5]._values["shareValue"].uintValue = 1;  
        _classes[5]._values["currency"].stringValue = "DAI";  

        _classes[5]._values["maxiumSupply"].uintValue = 4000000;  
        _classes[5]._values["callable"].boolValue = true;  
   
        _classes[5]._values["fixed-rate"].boolValue = true;  
        _classes[5]._values["APR"].uintValue = 135000;  
        _classes[5]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x560Ac248ce28972083B718778EEb0dbC2DE55740";
        emit classCreated(address(this), 5);

////////////////////////////////////////////////////////

        _classes[6]._values["symbol"].stringValue = "Branch-Series 3 (1754 Factory) -Junior Loan";
        _classes[6]._values["category"].stringValue = "loan";
        _classes[6]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[6]._values["childCategory"].stringValue = "emerging market consumer loan";
        
        _classes[6]._values["description"].stringValue = unicode"Branch is a financial technology company that lends money to consumers using machine learning algorithms to determine credit worthiness via customers' smartphones. Branch was founded in 2015 and has operations in Kenya, Nigeria, Tanzania, Mexico and India, and has since originated over $500M in loans to over 4 millions borrowers. This Tinlake pool will consist of tranches of a secured non convertible debenture with a maturity of 3 years backed by a portfolio of loans made to customers.The current weighted average loan balance is $49 (ranging from $6 to $2,500) with average maturity of 70 days.";
        _classes[6]._values["issuerName"].stringValue = "Branch (1754 Factory)";
        _classes[6]._values["issuerType"].stringValue = "LTD";
        _classes[6]._values["issuerJurisdiction"].stringValue = "US";
        _classes[6]._values["issuerURL"].stringValue = "https://www.1754.finance/";
        _classes[6]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Branch.png";
        _classes[6]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/BR3.pdf"
        ];
        _classes[6]._values["fundType"].stringValue = "corporate";  
        _classes[6]._values["shareValue"].uintValue = 1;  
        _classes[6]._values["currency"].stringValue = "DAI";  

        _classes[6]._values["maxiumSupply"].uintValue = 4000000;  
        _classes[6]._values["callable"].boolValue = true;  

        _classes[6]._values["fixed-rate"].boolValue = false;  
        _classes[6]._values["APR"].uintValue = 100000;  
        _classes[6]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x560Ac248ce28972083B718778EEb0dbC2DE55740";
        emit classCreated(address(this), 6);

//////////////////////////////////////////////////////

        _classes[7]._values["symbol"].stringValue = "REIF Financial Investments Inc. (REIF) -Senior Loan";
        _classes[7]._values["category"].stringValue = "loan";
        _classes[7]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[7]._values["childCategory"].stringValue = "commercial real estate";
        
        _classes[7]._values["description"].stringValue = unicode"REIF Financial Investments Inc. (REIF) is an asset management company focusing on acquiring commercial real estate assets from established asset originators. REIF was founded in 2021. REIF will loan capital secured by real estate to finance commercial and construction projects. This pool will consist of a portfolio of first and second secured position commercial real estate loans. The initial asset originator is Forge & Foster, a commercial real estate developer based in Ontario, Canada with $250 million CAD in assets under management of commercial real estate. The average maturity of assets is 18 months.";
        _classes[7]._values["issuerName"].stringValue = "Branch (1754 Factory)";
        _classes[7]._values["issuerType"].stringValue = "LTD";
        _classes[7]._values["issuerJurisdiction"].stringValue = "US";
        _classes[7]._values["issuerURL"].stringValue = "https://www.1754.finance/";
        _classes[7]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/REIF.png";
        _classes[7]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/REIF1.pdf"
        ];
        _classes[7]._values["fundType"].stringValue = "corporate";  
        _classes[7]._values["shareValue"].uintValue = 1;  
        _classes[7]._values["currency"].stringValue = "DAI";  

        _classes[7]._values["maxiumSupply"].uintValue = 3000000;  
        _classes[7]._values["callable"].boolValue = true;  
     
        _classes[7]._values["fixed-rate"].boolValue = true;  
        _classes[7]._values["APR"].uintValue = 50000;  
        _classes[7]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x09e43329552c9D81cF205Fd5f44796fBC40c822e";
        emit classCreated(address(this), 7);

//////////////////////////////////////////////////////

        _classes[8]._values["symbol"].stringValue = "REIF Financial Investments Inc. (REIF) -Junior Loan";
        _classes[8]._values["category"].stringValue = "loan";
        _classes[8]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[8]._values["childCategory"].stringValue = "commercial real estate";
        
        _classes[8]._values["description"].stringValue = unicode"REIF Financial Investments Inc. (REIF) is an asset management company focusing on acquiring commercial real estate assets from established asset originators. REIF was founded in 2021. REIF will loan capital secured by real estate to finance commercial and construction projects. This pool will consist of a portfolio of first and second secured position commercial real estate loans. The initial asset originator is Forge & Foster, a commercial real estate developer based in Ontario, Canada with $250 million CAD in assets under management of commercial real estate. The average maturity of assets is 18 months.";
        _classes[8]._values["issuerName"].stringValue = "Branch (1754 Factory)";
        _classes[8]._values["issuerType"].stringValue = "LTD";
        _classes[8]._values["issuerJurisdiction"].stringValue = "US";
        _classes[8]._values["issuerURL"].stringValue = "https://www.1754.finance/";
        _classes[8]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/REIF.png";
        _classes[8]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/REIF1.pdf"
        ];
        _classes[8]._values["fundType"].stringValue = "corporate";  
        _classes[8]._values["shareValue"].uintValue = 1;  
        _classes[8]._values["currency"].stringValue = "DAI";  

        _classes[8]._values["maxiumSupply"].uintValue = 3000000;  
        _classes[8]._values["callable"].boolValue = true;  
     
        _classes[8]._values["fixed-rate"].boolValue = false;  
        _classes[8]._values["APR"].uintValue = 50000;  
        _classes[8]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x09e43329552c9D81cF205Fd5f44796fBC40c822e";
        emit classCreated(address(this), 8);

//////////////////////////////////////////////////////

        _classes[9]._values["symbol"].stringValue = "Fortunafi-Series 1 -Senior Loan";
        _classes[9]._values["category"].stringValue = "loan";
        _classes[9]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[9]._values["childCategory"].stringValue = "revenue based financing";
        
        _classes[9]._values["description"].stringValue = unicode"Fortunafi Asset Management is a technology enabled revenue based finance provider. Revenue based financing provides capital to small or growing businesses in return for a fixed percentage of ongoing gross revenues. Thus payments increase and decrease based on business revenues, typically measured as monthly revenue. Usually the returns to the investor continue until the initial capital amount, plus a multiple (also known as a cap) is repaid. This Tinlake pool is composed of a portfolio of revenue based financing agreements with an average maturity of twenty four months.";
        _classes[9]._values["issuerName"].stringValue = "Fortunafi";
        _classes[9]._values["issuerType"].stringValue = "LTD";
        _classes[9]._values["issuerJurisdiction"].stringValue = "US";
        _classes[9]._values["issuerURL"].stringValue = "https://www.fortunafi.com/";
        _classes[9]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Fortunafi.png";
        _classes[9]._values["issuerDocURL"].stringArrayValue = [
            "https://docsend.com/view/s/gressukfmvcp6uip"
        ];
        _classes[9]._values["fundType"].stringValue = "corporate";  
        _classes[9]._values["shareValue"].uintValue = 1;  
        _classes[9]._values["currency"].stringValue = "DAI";  

        _classes[9]._values["maxiumSupply"].uintValue = 0;  
        _classes[9]._values["callable"].boolValue = true;  
     
        _classes[9]._values["fixed-rate"].boolValue = true;  
        _classes[9]._values["APR"].uintValue = 50000;  
        _classes[9]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x4B6CA198d257D755A5275648D471FE09931b764A";
        emit classCreated(address(this), 9);

//////////////////////////////////////////////////////

        _classes[10]._values["symbol"].stringValue = "Fortunafi-Series 1 -Junior Loan";
        _classes[10]._values["category"].stringValue = "loan";
        _classes[10]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[10]._values["childCategory"].stringValue = "whole loan";
        
        _classes[10]._values["description"].stringValue = unicode"Fortunafi Asset Management is a technology enabled revenue based finance provider. Revenue based financing provides capital to small or growing businesses in return for a fixed percentage of ongoing gross revenues. Thus payments increase and decrease based on business revenues, typically measured as monthly revenue. Usually the returns to the investor continue until the initial capital amount, plus a multiple (also known as a cap) is repaid. This Tinlake pool is composed of a portfolio of revenue based financing agreements with an average maturity of twenty four months.";
        _classes[10]._values["issuerName"].stringValue = "Fortunafi";
        _classes[10]._values["issuerType"].stringValue = "LTD";
        _classes[10]._values["issuerJurisdiction"].stringValue = "US";
        _classes[10]._values["issuerURL"].stringValue = "https://www.fortunafi.com/";
        _classes[10]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Fortunafi.png";
        _classes[10]._values["issuerDocURL"].stringArrayValue = [
            "https://docsend.com/view/s/gressukfmvcp6uip"
        ];
        _classes[10]._values["fundType"].stringValue = "corporate";  
        _classes[10]._values["shareValue"].uintValue = 1;  
        _classes[10]._values["currency"].stringValue = "DAI";  

        _classes[10]._values["maxiumSupply"].uintValue = 3100000;  
        _classes[10]._values["callable"].boolValue = true;  
      
        _classes[10]._values["fixed-rate"].boolValue = false;  
        _classes[10]._values["APR"].uintValue = 50000;  
        _classes[10]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x4B6CA198d257D755A5275648D471FE09931b764A";
        emit classCreated(address(this), 10);

////////////////////////////////////////////////////////

        _classes[11]._values["symbol"].stringValue = "BlockTower-Series 1 -Junior Loan";
        _classes[11]._values["category"].stringValue = "loan";
        _classes[11]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[11]._values["childCategory"].stringValue = "structured credit";
        
        _classes[11]._values["description"].stringValue = unicode"BlockTower Credit is the credit franchise of BlockTower Capital, an SEC-registered digital asset and blockchain investment firm founded in 2017. Within BlockTower Credit, we apply the skills of professional underwriting, structuring and investing at the intersection of real-world credit (a massive but anachronistic traditional industry) and crypto. This Tinlake Pool deploys capital into Structured Credit products will have an investment-grade rating and typically maintain a weighted average life (WAL) of less than four years. The Structured Credit products will generally fall into three major buckets: consumer ABS, auto ABS, and CLO.";
        _classes[11]._values["issuerName"].stringValue = "BlockTower";
        _classes[11]._values["issuerType"].stringValue = "LTD";
        _classes[11]._values["issuerJurisdiction"].stringValue = "US";
        _classes[11]._values["issuerURL"].stringValue = "https://www.blocktower.com/";
        _classes[11]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Blocktower.png";
        _classes[11]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/BT1.pdf"
        ];
        _classes[11]._values["fundType"].stringValue = "corporate";  
        _classes[11]._values["shareValue"].uintValue = 1;  
        _classes[11]._values["currency"].stringValue = "DAI";  

        _classes[11]._values["maxiumSupply"].uintValue = 0;  
        _classes[11]._values["callable"].boolValue = true;  
     
        _classes[11]._values["fixed-rate"].boolValue = true;  
        _classes[11]._values["APR"].uintValue = 50000;  
        _classes[11]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x4597f91cC06687Bdb74147C80C097A79358Ed29b";
        emit classCreated(address(this), 11);

////////////////////////////////////////////////////////

        _classes[12]._values["symbol"].stringValue = "BlockTower-Series 1 -Senior Loan";
        _classes[12]._values["category"].stringValue = "loan";
        _classes[12]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[12]._values["childCategory"].stringValue = "whole loan";
        
        _classes[12]._values["description"].stringValue = unicode"BlockTower Credit is the credit franchise of BlockTower Capital, an SEC-registered digital asset and blockchain investment firm founded in 2017. Within BlockTower Credit, we apply the skills of professional underwriting, structuring and investing at the intersection of real-world credit (a massive but anachronistic traditional industry) and crypto. This Tinlake Pool deploys capital into Structured Credit products will have an investment-grade rating and typically maintain a weighted average life (WAL) of less than four years. The Structured Credit products will generally fall into three major buckets: consumer ABS, auto ABS, and CLO.";
        _classes[12]._values["issuerName"].stringValue = "BlockTower";
        _classes[12]._values["issuerType"].stringValue = "LTD";
        _classes[12]._values["issuerJurisdiction"].stringValue = "US";
        _classes[12]._values["issuerURL"].stringValue = "https://www.blocktower.com/";
        _classes[12]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Blocktower.png";
        _classes[12]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/BT1.pdf"
        ];
        _classes[12]._values["fundType"].stringValue = "corporate";  
        _classes[12]._values["shareValue"].uintValue = 1;  
        _classes[12]._values["currency"].stringValue = "DAI";  

        _classes[12]._values["maxiumSupply"].uintValue = 20000000;  
        _classes[12]._values["callable"].boolValue = true;  

        _classes[12]._values["fixed-rate"].boolValue = false; 
        _classes[12]._values["APR"].uintValue = 40000;   
        _classes[12]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x4597f91cC06687Bdb74147C80C097A79358Ed29b";
        emit classCreated(address(this), 12);

////////////////////////////////////////////////////////

        _classes[13]._values["symbol"].stringValue = "BlockTower-Series 2 -Senior Loan";
        _classes[13]._values["category"].stringValue = "loan";
        _classes[13]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[13]._values["childCategory"].stringValue = "debt facilitie";
        
        _classes[13]._values["description"].stringValue = unicode"BlockTower Credit is the credit franchise of BlockTower Capital, an SEC-registered digital asset and blockchain investment firm founded in 2017. Within BlockTower Credit, we apply the skills of professional underwriting, structuring and investing at the intersection of real-world credit (a massive but anachronistic traditional industry) and crypto. This Tinlake Pool deploys capital into Structured Credit products will have an investment-grade rating and typically maintain a weighted average life (WAL) of less than four years. The Structured Credit products will generally fall into three major buckets: consumer ABS, auto ABS, and CLO.";
        _classes[13]._values["issuerName"].stringValue = "BlockTower";
        _classes[13]._values["issuerType"].stringValue = "LTD";
        _classes[13]._values["issuerJurisdiction"].stringValue = "US";
        _classes[13]._values["issuerURL"].stringValue = "https://www.blocktower.com/";
        _classes[13]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Blocktower.png";
        _classes[13]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/BT2.pdf"
        ];
        _classes[13]._values["fundType"].stringValue = "corporate";  
        _classes[13]._values["shareValue"].uintValue = 1;  
        _classes[13]._values["currency"].stringValue = "DAI";  

        _classes[13]._values["maxiumSupply"].uintValue = 0;  
        _classes[13]._values["callable"].boolValue = true;  

        _classes[13]._values["fixed-rate"].boolValue = true;  
        _classes[13]._values["APR"].uintValue = 40000;  
        _classes[13]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0xB5c08534d1E73582FBd79e7C45694CAD6A5C5aB2";
        emit classCreated(address(this), 13);

////////////////////////////////////////////////////////

        _classes[14]._values["symbol"].stringValue = "BlockTower-Series 2 -Junior Loan";
        _classes[14]._values["category"].stringValue = "loan";
        _classes[14]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[14]._values["childCategory"].stringValue = "debt facilitie";
        
        _classes[14]._values["description"].stringValue = unicode"BlockTower Credit is the credit franchise of BlockTower Capital, an SEC-registered digital asset and blockchain investment firm founded in 2017. Within BlockTower Credit, we apply the skills of professional underwriting, structuring and investing at the intersection of real-world credit (a massive but anachronistic traditional industry) and crypto. This Tinlake Pool deploys capital into Structured Credit products will have an investment-grade rating and typically maintain a weighted average life (WAL) of less than four years. The Structured Credit products will generally fall into three major buckets: consumer ABS, auto ABS, and CLO.";
        _classes[14]._values["issuerName"].stringValue = "BlockTower";
        _classes[14]._values["issuerType"].stringValue = "LTD";
        _classes[14]._values["issuerJurisdiction"].stringValue = "US";
        _classes[14]._values["issuerURL"].stringValue = "https://www.blocktower.com/";
        _classes[14]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Blocktower.png";
        _classes[14]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/BT2.pdf"
        ];
        _classes[14]._values["fundType"].stringValue = "corporate";  
        _classes[14]._values["shareValue"].uintValue = 1;  
        _classes[14]._values["currency"].stringValue = "DAI";  

        _classes[14]._values["maxiumSupply"].uintValue = 30000000;  
        _classes[14]._values["callable"].boolValue = true;  
  
        _classes[14]._values["fixed-rate"].boolValue = false;  
        _classes[14]._values["APR"].uintValue = 40000;  
        _classes[14]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0xB5c08534d1E73582FBd79e7C45694CAD6A5C5aB2";
        emit classCreated(address(this), 14);

////////////////////////////////////////////////////////

        _classes[15]._values["symbol"].stringValue = "New Silver-Series 2 -Senior Loan";
        _classes[15]._values["category"].stringValue = "loan";
        _classes[15]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[15]._values["childCategory"].stringValue = "real estate bridge loan";
        
        _classes[15]._values["description"].stringValue = unicode"Founded in 2018, New Silver is a technology enabled non-bank lender primarily focused on providing real estate-backed financing for the United States “fix and flip” sector with a concentration on single-family residential assets. Bridge loans, also referred to as fix and flip loans allow real estate investors to finance both the purchase and the construction, or in some cases, refinance an existing investment property with sufficient equity. This Tinlake pool is financing a portfolio of real estate bridge loans that are extended to real estate developers with a maturity of twelve to twenty four months.";
        _classes[15]._values["issuerName"].stringValue = "New Silver";
        _classes[15]._values["issuerType"].stringValue = "LTD";
        _classes[15]._values["issuerJurisdiction"].stringValue = "US";
        _classes[15]._values["issuerURL"].stringValue = "https://newsilver.com/";
        _classes[15]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/New%20Silver.png";
        _classes[15]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/NS2.pdf"
        ];
        _classes[15]._values["fundType"].stringValue = "corporate";  
        _classes[15]._values["shareValue"].uintValue = 1;  
        _classes[15]._values["currency"].stringValue = "DAI";  

        _classes[15]._values["maxiumSupply"].uintValue = 7000000;  
        _classes[15]._values["callable"].boolValue = true;  
    
        _classes[15]._values["fixed-rate"].boolValue = true;  
        _classes[15]._values["APR"].uintValue = 40000;  
        _classes[15]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x53b2d22d07E069a3b132BfeaaD275b10273d381E";
        emit classCreated(address(this), 15);

////////////////////////////////////////////////////////

        _classes[16]._values["symbol"].stringValue = "New Silver-Series 2 -Junior Loan";
        _classes[16]._values["category"].stringValue = "loan";
        _classes[16]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[16]._values["childCategory"].stringValue = "real estate bridge loan";
        
        _classes[16]._values["description"].stringValue = unicode"Founded in 2018, New Silver is a technology enabled non-bank lender primarily focused on providing real estate-backed financing for the United States “fix and flip” sector with a concentration on single-family residential assets. Bridge loans, also referred to as fix and flip loans allow real estate investors to finance both the purchase and the construction, or in some cases, refinance an existing investment property with sufficient equity. This Tinlake pool is financing a portfolio of real estate bridge loans that are extended to real estate developers with a maturity of twelve to twenty four months.";
        _classes[16]._values["issuerName"].stringValue = "New Silver";
        _classes[16]._values["issuerType"].stringValue = "LTD";
        _classes[16]._values["issuerJurisdiction"].stringValue = "US";
        _classes[16]._values["issuerURL"].stringValue = "https://newsilver.com/";
        _classes[16]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/New%20Silver.png";
        _classes[16]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/NS2.pdf"
        ];
        _classes[16]._values["fundType"].stringValue = "corporate";  
        _classes[16]._values["shareValue"].uintValue = 1;  
        _classes[16]._values["currency"].stringValue = "DAI";  

        _classes[16]._values["maxiumSupply"].uintValue = 7000000;  
        _classes[16]._values["callable"].boolValue = true;  
     
        _classes[16]._values["fixed-rate"].boolValue = false;  
        _classes[16]._values["APR"].uintValue = 40000;  
        _classes[16]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x53b2d22d07E069a3b132BfeaaD275b10273d381E";
        emit classCreated(address(this), 16);

////////////////////////////////////////////////////////

        _classes[17]._values["symbol"].stringValue = "Cauris Global Fintech-Fund 1 -Senior Loan";
        _classes[17]._values["category"].stringValue = "loan";
        _classes[17]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[17]._values["childCategory"].stringValue = "fintech debt financing";
        
        _classes[17]._values["description"].stringValue = unicode"Cauris is a DeFi debt fund with the mission of giving access to capital to 100 million people across the world. The pool seeks to generate uncorrelated and excess risk-adjusted returns to its investors by providing secured loans to fintechs that lend to consumers and small businesses in the Global South and Europe. Cauris was founded in 2021 and has since originated over $5M in loans that impacted over 300,000 borrowers. This Tinlake pool will consist of tranches of secured debentures with maturities ranging from one to three years.";
        _classes[17]._values["issuerName"].stringValue = "Cauris Global Fintech";
        _classes[17]._values["issuerType"].stringValue = "LTD";
        _classes[17]._values["issuerJurisdiction"].stringValue = "US";
        _classes[17]._values["issuerURL"].stringValue = "https://caurisfinance.com/";
        _classes[17]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Cauris.png";
        _classes[17]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/CGFF1.pdf"
        ];
        _classes[17]._values["fundType"].stringValue = "corporate";  
        _classes[17]._values["shareValue"].uintValue = 1;  
        _classes[17]._values["currency"].stringValue = "DAI";  

        _classes[17]._values["maxiumSupply"].uintValue = 4500000;  
        _classes[17]._values["callable"].boolValue = true;  
    
        _classes[17]._values["fixed-rate"].boolValue = true;  
        _classes[17]._values["APR"].uintValue = 85000;  
        _classes[17]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x53b2d22d07E069a3b132BfeaaD275b10273d381E";
        emit classCreated(address(this), 17);

////////////////////////////////////////////////////////

        _classes[18]._values["symbol"].stringValue = "Cauris Global Fintech-Fund 1 -Junior Loan";
        _classes[18]._values["category"].stringValue = "loan";
        _classes[18]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[18]._values["childCategory"].stringValue = "fintech debt financing";
        
        _classes[18]._values["description"].stringValue = unicode"Cauris is a DeFi debt fund with the mission of giving access to capital to 100 million people across the world. The pool seeks to generate uncorrelated and excess risk-adjusted returns to its investors by providing secured loans to fintechs that lend to consumers and small businesses in the Global South and Europe. Cauris was founded in 2021 and has since originated over $5M in loans that impacted over 300,000 borrowers. This Tinlake pool will consist of tranches of secured debentures with maturities ranging from one to three years.";
        _classes[18]._values["issuerName"].stringValue = "Cauris Global Fintech";
        _classes[18]._values["issuerType"].stringValue = "LTD";
        _classes[18]._values["issuerJurisdiction"].stringValue = "US";
        _classes[18]._values["issuerURL"].stringValue = "https://caurisfinance.com/";
        _classes[18]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Cauris.png";
        _classes[18]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/CGFF1.pdf"
        ];
        _classes[18]._values["fundType"].stringValue = "corporate";  
        _classes[18]._values["shareValue"].uintValue = 1;  
        _classes[18]._values["currency"].stringValue = "DAI";  

        _classes[18]._values["maxiumSupply"].uintValue = 9000000;  
        _classes[18]._values["callable"].boolValue = true;  
    
        _classes[18]._values["fixed-rate"].boolValue = false;  
        _classes[18]._values["APR"].uintValue = 85000; 
        _classes[18]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x53b2d22d07E069a3b132BfeaaD275b10273d381E";
        emit classCreated(address(this), 18);

////////////////////////////////////////////////////////

        _classes[19]._values["symbol"].stringValue = "ALT 1.0 SPV -Senior Loan";
        _classes[19]._values["category"].stringValue = "loan";
        _classes[19]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[19]._values["childCategory"].stringValue = "invoice financing and accounts receivable";
        
        _classes[19]._values["description"].stringValue = unicode"Alternative is reimagining financial services, beginning with lending, providing companies with simple, customizable financing solutions. We are fully tech-enabled and offer solutions directly to businesses as well as to businesses' end-customers. Our solutions are unique, simplistic and streamline the entire financing process so that companies may access funding on their terms.";
        _classes[19]._values["issuerName"].stringValue = "Alternative Payments";
        _classes[19]._values["issuerType"].stringValue = "LTD";
        _classes[19]._values["issuerJurisdiction"].stringValue = "US";
        _classes[19]._values["issuerURL"].stringValue = "https://www.alternativepayments.io/";
        _classes[19]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Alternative%20Payments.png";
        _classes[19]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/ALT1.pdf"
        ];
        _classes[19]._values["fundType"].stringValue = "corporate";  
        _classes[19]._values["shareValue"].uintValue = 1;  
        _classes[19]._values["currency"].stringValue = "DAI";  

        _classes[19]._values["maxiumSupply"].uintValue = 263800;  
        _classes[19]._values["callable"].boolValue = true;  

        _classes[19]._values["fixed-rate"].boolValue = true;  
        _classes[19]._values["APR"].uintValue = 77000;  
        _classes[19]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0xF96F18F2c70b57Ec864cC0C8b828450b82Ff63e3";
        emit classCreated(address(this), 19);

////////////////////////////////////////////////////////

        _classes[20]._values["symbol"].stringValue = "ALT 1.0 SPV -Junior Loan";
        _classes[20]._values["category"].stringValue = "loan";
        _classes[20]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[20]._values["childCategory"].stringValue = "invoice financing and accounts receivable";
        
        _classes[20]._values["description"].stringValue = unicode"Alternative is reimagining financial services, beginning with lending, providing companies with simple, customizable financing solutions. We are fully tech-enabled and offer solutions directly to businesses as well as to businesses' end-customers. Our solutions are unique, simplistic and streamline the entire financing process so that companies may access funding on their terms.";
        _classes[20]._values["issuerName"].stringValue = "Alternative Payments";
        _classes[20]._values["issuerType"].stringValue = "LTD";
        _classes[20]._values["issuerJurisdiction"].stringValue = "US";
        _classes[20]._values["issuerURL"].stringValue = "https://www.alternativepayments.io/";
        _classes[20]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Alternative%20Payments.png";
        _classes[20]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/ALT1.pdf"
        ];
        _classes[20]._values["fundType"].stringValue = "corporate";  
        _classes[20]._values["shareValue"].uintValue = 1;  
        _classes[20]._values["currency"].stringValue = "DAI";  

        _classes[20]._values["maxiumSupply"].uintValue = 6200000;  
        _classes[20]._values["callable"].boolValue = true;  

        _classes[20]._values["fixed-rate"].boolValue = false;  
        _classes[20]._values["APR"].uintValue = 77000;  
        _classes[20]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0xF96F18F2c70b57Ec864cC0C8b828450b82Ff63e3";
        emit classCreated(address(this), 20);

////////////////////////////////////////////////////////

        _classes[21]._values["symbol"].stringValue = "1754 Factory (Bling Series 1) -Senior Loan";
        _classes[21]._values["category"].stringValue = "loan";
        _classes[21]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[21]._values["childCategory"].stringValue = "payment advance";
        
        _classes[21]._values["description"].stringValue = unicode"1754 Factory LLC is a Delaware Series LLC created and managed by Davoa Capital to provide short term cash advances to Bling customers. Bling is a mobile app for french consumers that offers cash advances up to €200. 1754 Factory has entered into an institutional purchase agreement to buy Bling bonds. Bling bonds are sold at par at €10,000 and they include over 125 micro loans that average €80. This Tinlake pool launched with 17 longer term Bling bonds and intends to steadily grow the pool with a rolling maturity of ninety days to provide frequent liquidity.";
        _classes[21]._values["issuerName"].stringValue = "1754 Factory";
        _classes[21]._values["issuerType"].stringValue = "LTD";
        _classes[21]._values["issuerJurisdiction"].stringValue = "US";
        _classes[21]._values["issuerURL"].stringValue = "https://www.1754.finance/";
        _classes[21]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/1754%20Factory.png";
        _classes[21]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/BL1.pdf"
        ];
        _classes[21]._values["fundType"].stringValue = "corporate";  
        _classes[21]._values["shareValue"].uintValue = 1;  
        _classes[21]._values["currency"].stringValue = "DAI";  

        _classes[21]._values["maxiumSupply"].uintValue = 0;  
        _classes[21]._values["callable"].boolValue = true;  
        _classes[21]._values["fixed-rate"].boolValue = true;  
        _classes[21]._values["APR"].uintValue = 75000;  
        _classes[21]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x0CED6166873038Ac0cc688e7E6d19E2cBE251Bf0";
        emit classCreated(address(this), 21);

////////////////////////////////////////////////////////

        _classes[22]._values["symbol"].stringValue = "1754 Factory (Bling Series 1) -Junior Loan";
        _classes[22]._values["category"].stringValue = "loan";
        _classes[22]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[22]._values["childCategory"].stringValue = "payment advance";
        
        _classes[22]._values["description"].stringValue = unicode"1754 Factory LLC is a Delaware Series LLC created and managed by Davoa Capital to provide short term cash advances to Bling customers. Bling is a mobile app for french consumers that offers cash advances up to €200. 1754 Factory has entered into an institutional purchase agreement to buy Bling bonds. Bling bonds are sold at par at €10,000 and they include over 125 micro loans that average €80. This Tinlake pool launched with 17 longer term Bling bonds and intends to steadily grow the pool with a rolling maturity of ninety days to provide frequent liquidity.";
        _classes[22]._values["issuerName"].stringValue = "1754 Factory";
        _classes[22]._values["issuerType"].stringValue = "LTD";
        _classes[22]._values["issuerJurisdiction"].stringValue = "US";
        _classes[22]._values["issuerURL"].stringValue = "https://www.1754.finance/";
        _classes[22]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/1754%20Factory.png";
        _classes[22]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/BL1.pdf"
        ];
        _classes[22]._values["fundType"].stringValue = "corporate";  
        _classes[22]._values["shareValue"].uintValue = 1;  
        _classes[22]._values["currency"].stringValue = "DAI";  

        _classes[22]._values["maxiumSupply"].uintValue = 0;  
        _classes[22]._values["callable"].boolValue = true;  
        _classes[22]._values["fixed-rate"].boolValue = false;  
        _classes[22]._values["APR"].uintValue = 75000;  
        _classes[22]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x0CED6166873038Ac0cc688e7E6d19E2cBE251Bf0";
        emit classCreated(address(this), 22);

////////////////////////////////////////////////////////

        _classes[23]._values["symbol"].stringValue = "ConsolFreight-Series 4 -Senior Loan";
        _classes[23]._values["category"].stringValue = "loan";
        _classes[23]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[23]._values["childCategory"].stringValue = "cargo & freight forwarding invoice";
        
        _classes[23]._values["description"].stringValue = unicode"ConsolFreight is a trade finance and factoring provider focused on helping SMEs and developing countries. CFs advances working capital finance to stakeholders involved in international trading of goods and services. ConsolFreight is active in both trade finance and freight forwarding transactions. Trade finance transactions involve advancing capital to shippers and collecting from the buyers, while financing freight forwarding invoices involves advancing funds to freight forwarders and collecting from shippers. This Tinlake pool is financing a combined portfolio of trade finance transactions and freight forwarding invoices with a 30 to 90 day maturity.";
        _classes[23]._values["issuerName"].stringValue = "ConsolFreight";
        _classes[23]._values["issuerType"].stringValue = "LTD";
        _classes[23]._values["issuerJurisdiction"].stringValue = "US";
        _classes[23]._values["issuerURL"].stringValue = "https://www.consolfreight.io/";
        _classes[23]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/consolfreight.png";
        _classes[23]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/CF4.pdf"
        ];
        _classes[23]._values["fundType"].stringValue = "corporate";  
        _classes[23]._values["shareValue"].uintValue = 1;  
        _classes[23]._values["currency"].stringValue = "DAI";  

        _classes[23]._values["maxiumSupply"].uintValue = 3800000;  
        _classes[23]._values["callable"].boolValue = true;  
        _classes[23]._values["fixed-rate"].boolValue = true;  
        _classes[23]._values["APR"].uintValue = 60000;  
        _classes[23]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0xdB3bC9fB1893222d266762e9fF857EB74D75c7D6";
        emit classCreated(address(this), 23);

////////////////////////////////////////////////////////

        _classes[24]._values["symbol"].stringValue = "ConsolFreight-Series 4 -Junior Loan";
        _classes[24]._values["category"].stringValue = "loan";
        _classes[24]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[24]._values["childCategory"].stringValue = "cargo & freight forwarding invoice";
        
        _classes[24]._values["description"].stringValue = unicode"ConsolFreight is a trade finance and factoring provider focused on helping SMEs and developing countries. CFs advances working capital finance to stakeholders involved in international trading of goods and services. ConsolFreight is active in both trade finance and freight forwarding transactions. Trade finance transactions involve advancing capital to shippers and collecting from the buyers, while financing freight forwarding invoices involves advancing funds to freight forwarders and collecting from shippers. This Tinlake pool is financing a combined portfolio of trade finance transactions and freight forwarding invoices with a 30 to 90 day maturity.";
        _classes[24]._values["issuerName"].stringValue = "ConsolFreight";
        _classes[24]._values["issuerType"].stringValue = "LTD";
        _classes[24]._values["issuerJurisdiction"].stringValue = "US";
        _classes[24]._values["issuerURL"].stringValue = "https://www.consolfreight.io/";
        _classes[24]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/consolfreight.png";
        _classes[24]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/CF4.pdf"
        ];
        _classes[24]._values["fundType"].stringValue = "corporate";  
        _classes[24]._values["shareValue"].uintValue = 1;  
        _classes[24]._values["currency"].stringValue = "DAI";  

        _classes[24]._values["maxiumSupply"].uintValue = 9300000;  
        _classes[24]._values["callable"].boolValue = true;  

        _classes[24]._values["fixed-rate"].boolValue = false;  
        _classes[24]._values["APR"].uintValue = 60000;  
        _classes[24]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x0CED6166873038Ac0cc688e7E6d19E2cBE251Bf0";
        emit classCreated(address(this), 24);

////////////////////////////////////////////////////////

        _classes[25]._values["symbol"].stringValue = "Harbor Trade Credit-Series 2 -Senior Loan";
        _classes[25]._values["category"].stringValue = "loan";
        _classes[25]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[25]._values["childCategory"].stringValue = "trade receivable";
        
        _classes[25]._values["description"].stringValue = unicode"Harbor is a fintech company focused on Supply Chain Finance (SCF) and working capital solutions to improve the cash conversion cycle. Harbor's trade finance programs accelerate supplier payments to achieve buyer and supplier's liquidity needs. This Tinlake pool is financing a portfolio of SCF invoices with a typical maturity of sixty to one hundred twenty days.";
        _classes[25]._values["issuerName"].stringValue = "Harbor";
        _classes[25]._values["issuerType"].stringValue = "LTD";
        _classes[25]._values["issuerJurisdiction"].stringValue = "US";
        _classes[25]._values["issuerURL"].stringValue = "https://harbortrade.com/";
        _classes[25]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/harbortrade.png";
        _classes[25]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/HTC2.pdf"
        ];
        _classes[25]._values["fundType"].stringValue = "corporate";  
        _classes[25]._values["shareValue"].uintValue = 1;  
        _classes[25]._values["currency"].stringValue = "DAI";  

        _classes[25]._values["maxiumSupply"].uintValue = 29200;  
        _classes[25]._values["callable"].boolValue = true;  
        _classes[25]._values["maturityPeriod"].uintValue = 322*60*60*24;  

        _classes[25]._values["fixed-rate"].boolValue = true;  
        _classes[25]._values["APR"].uintValue = 70000;  
        _classes[25]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x4cA805cE8EcE2E63FfC1F9f8F2731D3F48DF89Df";
        emit classCreated(address(this), 25);

////////////////////////////////////////////////////////

        _classes[26]._values["symbol"].stringValue = "Harbor Trade Credit-Series 2 -Junior Loan";
        _classes[26]._values["category"].stringValue = "loan";
        _classes[26]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[26]._values["childCategory"].stringValue = "trade receivable";
        
        _classes[26]._values["description"].stringValue = unicode"Harbor is a fintech company focused on Supply Chain Finance (SCF) and working capital solutions to improve the cash conversion cycle. Harbor's trade finance programs accelerate supplier payments to achieve buyer and supplier's liquidity needs. This Tinlake pool is financing a portfolio of SCF invoices with a typical maturity of sixty to one hundred twenty days.";
        _classes[26]._values["issuerName"].stringValue = "Harbor";
        _classes[26]._values["issuerType"].stringValue = "LTD";
        _classes[26]._values["issuerJurisdiction"].stringValue = "US";
        _classes[26]._values["issuerURL"].stringValue = "https://harbortrade.com/";
        _classes[26]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/harbortrade.png";
        _classes[26]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/HTC2.pdf"
        ];
        _classes[26]._values["fundType"].stringValue = "corporate";  
        _classes[26]._values["shareValue"].uintValue = 1;  
        _classes[26]._values["currency"].stringValue = "DAI";  

        _classes[26]._values["maxiumSupply"].uintValue = 29200;  
        _classes[26]._values["callable"].boolValue = true;  
 
        _classes[26]._values["APR"].uintValue = 70000;  
        _classes[26]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x4cA805cE8EcE2E63FfC1F9f8F2731D3F48DF89Df";
        emit classCreated(address(this), 26);

////////////////////////////////////////////////////////

        _classes[27]._values["symbol"].stringValue = "Flowcarbon Nature Offsets-Series 1 -Senior Loan";
        _classes[27]._values["category"].stringValue = "loan";
        _classes[27]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[27]._values["childCategory"].stringValue = "voluntary carbon offset";
        
        _classes[27]._values["description"].stringValue = unicode"Flowcarbon is a pioneering climate tech company bringing carbon offsets onto the blockchain. Its mission is to make carbon markets accessible and transparent, enabling billions of dollars to be invested directly into projects that combat climate change. This first pool was created to finance important conservation work and carbon avoidance in the Corazón Verde Del Chaco Project (VCS 2611), located in Paraguay within the Gran Chaco Forest. The Gran Chaco is the second-largest forest in South America, behind only the Amazon rainforest and it has one of the highest deforestation rates on the planet due to conversion to cropland and pasture for cattle.";
        _classes[27]._values["issuerName"].stringValue = "Flowcarbon";
        _classes[27]._values["issuerType"].stringValue = "LTD";
        _classes[27]._values["issuerJurisdiction"].stringValue = "US";
        _classes[27]._values["issuerURL"].stringValue = "https://www.flowcarbon.com/";
        _classes[27]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Flowcarbon.png";
        _classes[27]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/FNO1.pdf"
        ];
        _classes[27]._values["fundType"].stringValue = "corporate";  
        _classes[27]._values["shareValue"].uintValue = 1;  
        _classes[27]._values["currency"].stringValue = "DAI";  

        _classes[27]._values["maxiumSupply"].uintValue = 0;  
        _classes[27]._values["callable"].boolValue = true;  
        _classes[27]._values["fixed-rate"].boolValue = true;  
        _classes[27]._values["APR"].uintValue = 150000;  
        _classes[27]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0xd8486C565098360A24f858088a6D29a380dDF7ec";
        emit classCreated(address(this), 27);

////////////////////////////////////////////////////////

        _classes[28]._values["symbol"].stringValue = "Flowcarbon Nature Offsets-Series 1 -Junior Loan";
        _classes[28]._values["category"].stringValue = "loan";
        _classes[28]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[28]._values["childCategory"].stringValue = "voluntary carbon offset";
        
        _classes[28]._values["description"].stringValue = unicode"Flowcarbon is a pioneering climate tech company bringing carbon offsets onto the blockchain. Its mission is to make carbon markets accessible and transparent, enabling billions of dollars to be invested directly into projects that combat climate change. This first pool was created to finance important conservation work and carbon avoidance in the Corazón Verde Del Chaco Project (VCS 2611), located in Paraguay within the Gran Chaco Forest. The Gran Chaco is the second-largest forest in South America, behind only the Amazon rainforest and it has one of the highest deforestation rates on the planet due to conversion to cropland and pasture for cattle.";
        _classes[28]._values["issuerName"].stringValue = "Flowcarbon";
        _classes[28]._values["issuerType"].stringValue = "LTD";
        _classes[28]._values["issuerJurisdiction"].stringValue = "US";
        _classes[28]._values["issuerURL"].stringValue = "https://www.flowcarbon.com/";
        _classes[28]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Flowcarbon.png";
        _classes[28]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/FNO1.pdf"
        ];
        _classes[28]._values["fundType"].stringValue = "corporate";  
        _classes[28]._values["shareValue"].uintValue = 1;  
        _classes[28]._values["currency"].stringValue = "DAI";  

        _classes[28]._values["maxiumSupply"].uintValue = 0;  
        _classes[28]._values["callable"].boolValue = true;  

        _classes[28]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0xd8486C565098360A24f858088a6D29a380dDF7ec";
        emit classCreated(address(this), 28);

////////////////////////////////////////////////////////

        _classes[29]._values["symbol"].stringValue = "databased.FINANCE 1-Senior Loan";
        _classes[29]._values["category"].stringValue = "loan";
        _classes[29]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[29]._values["childCategory"].stringValue = "branded inventory financing";
        
        _classes[29]._values["description"].stringValue = unicode"databased.FINANCE is launching its first Tinlake pool to purchase verified inventory from Amazon Sellers. We are an inventory technology provider that buys from Amazon Sellers who have a Sales History with Amazon and use Fulfilled By Amazon for managing their prepositioned inventory. We purchase their prepositioned inventory and charge a Limited Exclusive Rights Sales fee in 30 day cycles so they can sell it on our behalf. We use a third party Oracle service, Track.one Limited to access the account of the Amazon Seller and verify both historic price, sales volumes, and the current inventory holdings of the brand. This allows us to mark-to-market the value of the inventory. We call this type of finance databased.FINANCE.";
        _classes[29]._values["issuerName"].stringValue = "databased.FINANCE";
        _classes[29]._values["issuerType"].stringValue = "LTD";
        _classes[29]._values["issuerJurisdiction"].stringValue = "HK";
        _classes[29]._values["issuerURL"].stringValue = "https://www.databased.finance/";
        _classes[29]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Databased%20Finance.png";
        _classes[29]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/DF1.pdf"
        ];
        _classes[29]._values["fundType"].stringValue = "corporate";  
        _classes[29]._values["shareValue"].uintValue = 1;  
        _classes[29]._values["currency"].stringValue = "DAI";  

        _classes[29]._values["maxiumSupply"].uintValue = 600000;  
        _classes[29]._values["callable"].boolValue = true;  
        _classes[29]._values["maturityPeriod"].uintValue = 6*60*60*24;  
        _classes[29]._values["coupon"].boolValue = false;  
        _classes[29]._values["fixed-rate"].boolValue = true;  
        _classes[29]._values["APR"].uintValue = 8000;  
        _classes[29]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0xfc2950dD337ca8496C18dfc0256Fb905A7E7E5c6";
        emit classCreated(address(this), 29);

////////////////////////////////////////////////////////

        _classes[30]._values["symbol"].stringValue = "databased.FINANCE 1-Junior Loan";
        _classes[30]._values["category"].stringValue = "loan";
        _classes[30]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[30]._values["childCategory"].stringValue = "branded inventory financing";
        
        _classes[30]._values["description"].stringValue = unicode"databased.FINANCE is launching its first Tinlake pool to purchase verified inventory from Amazon Sellers. We are an inventory technology provider that buys from Amazon Sellers who have a Sales History with Amazon and use Fulfilled By Amazon for managing their prepositioned inventory. We purchase their prepositioned inventory and charge a Limited Exclusive Rights Sales fee in 30 day cycles so they can sell it on our behalf. We use a third party Oracle service, Track.one Limited to access the account of the Amazon Seller and verify both historic price, sales volumes, and the current inventory holdings of the brand. This allows us to mark-to-market the value of the inventory. We call this type of finance databased.FINANCE.";
        _classes[30]._values["issuerName"].stringValue = "databased.FINANCE";
        _classes[30]._values["issuerType"].stringValue = "LTD";
        _classes[30]._values["issuerJurisdiction"].stringValue = "HK";
        _classes[30]._values["issuerURL"].stringValue = "https://www.databased.finance/";
        _classes[30]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Databased%20Finance.png";
        _classes[30]._values["issuerDocURL"].stringArrayValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/DF1.pdf"
        ];
        _classes[30]._values["fundType"].stringValue = "corporate";  
        _classes[30]._values["shareValue"].uintValue = 1;  
        _classes[30]._values["currency"].stringValue = "DAI";  

        _classes[30]._values["maxiumSupply"].uintValue = 600000;  
        _classes[30]._values["callable"].boolValue = true;  
        _classes[30]._values["maturityPeriod"].uintValue = 6*60*60*24;  
        _classes[30]._values["coupon"].boolValue = false;  
        _classes[30]._values["fixed-rate"].boolValue = false;  
        _classes[30]._values["APR"].uintValue = 8000;  
        _classes[30]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0xfc2950dD337ca8496C18dfc0256Fb905A7E7E5c6";
        emit classCreated(address(this), 30);







    }
   
}

