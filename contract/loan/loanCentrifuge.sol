

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
        _classes[1]._values["issuerDocURL"].stringValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/BT4.pdf"
        ];
        _classes[1]._values["fundType"].stringValue = "corporate";  
        _classes[1]._values["shareValue"].uintValue = 1;  
        _classes[1]._values["currency"].stringValue = "DAI";  

        _classes[1]._values["maxiumSupply"].uintValue = 1200000;  
        _classes[1]._values["callable"].boolValue = true;  
        _classes[1]._values["maturityPeriod"].uintValue = 322*60*60*24;  
        _classes[1]._values["coupon"].boolValue = true;  
        _classes[1]._values["couponRate"].uintValue = 3333;  
        _classes[1]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[1]._values["fixed-rate"].boolValue = true;  
        _classes[1]._values["APY"].uintValue = 40000;  
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
        _classes[2]._values["issuerDocURL"].stringValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/BT4.pdf"
        ];
        _classes[2]._values["fundType"].stringValue = "corporate";  
        _classes[2]._values["shareValue"].uintValue = 1;  
        _classes[2]._values["currency"].stringValue = "DAI";  

        _classes[2]._values["maxiumSupply"].uintValue = 69700000;  
        _classes[2]._values["callable"].boolValue = true;  
        _classes[2]._values["maturityPeriod"].uintValue = 322*60*60*24;  
        _classes[2]._values["coupon"].boolValue = true;  
        _classes[2]._values["couponRate"].uintValue = 11250;  
        _classes[2]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[2]._values["fixed-rate"].boolValue = false;  
        _classes[2]._values["APY"].uintValue = ;  
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
        _classes[3]._values["issuerDocURL"].stringValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/BT3.pdf"
        ];
        _classes[3]._values["fundType"].stringValue = "corporate";  
        _classes[3]._values["shareValue"].uintValue = 1;  
        _classes[3]._values["currency"].stringValue = "DAI";  

        _classes[3]._values["maxiumSupply"].uintValue = 11200000;  
        _classes[3]._values["callable"].boolValue = true;  
        _classes[3]._values["maturityPeriod"].uintValue = 322*60*60*24;  
        _classes[3]._values["coupon"].boolValue = true;  
        _classes[3]._values["couponRate"].uintValue = 3333;  
        _classes[3]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[3]._values["fixed-rate"].boolValue = ture;  
        _classes[3]._values["APY"].uintValue = 40000;  
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
        _classes[4]._values["issuerDocURL"].stringValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/BT3.pdf"
        ];
        _classes[4]._values["fundType"].stringValue = "corporate";  
        _classes[4]._values["shareValue"].uintValue = 1;  
        _classes[4]._values["currency"].stringValue = "DAI";  

        _classes[4]._values["maxiumSupply"].uintValue = 19000000;  
        _classes[4]._values["callable"].boolValue = true;  
        _classes[4]._values["maturityPeriod"].uintValue = 322*60*60*24;  
        _classes[4]._values["coupon"].boolValue = true;  
        _classes[4]._values["couponRate"].uintValue = 11250;  
        _classes[4]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[4]._values["fixed-rate"].boolValue = false;  
        _classes[4]._values["APY"].uintValue = 135000;  
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
        _classes[5]._values["issuerDocURL"].stringValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/BR3.pdf"
        ];
        _classes[5]._values["fundType"].stringValue = "corporate";  
        _classes[5]._values["shareValue"].uintValue = 1;  
        _classes[5]._values["currency"].stringValue = "DAI";  

        _classes[5]._values["maxiumSupply"].uintValue = 4000000;  
        _classes[5]._values["callable"].boolValue = true;  
        _classes[5]._values["maturityPeriod"].uintValue = 322*60*60*24;  
        _classes[5]._values["coupon"].boolValue = true;  
        _classes[5]._values["couponRate"].uintValue = 11250;  
        _classes[5]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[5]._values["fixed-rate"].boolValue = ture;  
        _classes[5]._values["APY"].uintValue = 135000;  
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
        _classes[6]._values["issuerDocURL"].stringValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/BR3.pdf"
        ];
        _classes[6]._values["fundType"].stringValue = "corporate";  
        _classes[6]._values["shareValue"].uintValue = 1;  
        _classes[6]._values["currency"].stringValue = "DAI";  

        _classes[6]._values["maxiumSupply"].uintValue = 4000000;  
        _classes[6]._values["callable"].boolValue = true;  
        _classes[6]._values["maturityPeriod"].uintValue = 322*60*60*24;  
        _classes[6]._values["coupon"].boolValue = true;  
        _classes[6]._values["couponRate"].uintValue = 11250;  
        _classes[6]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[6]._values["fixed-rate"].boolValue = false;  
        _classes[6]._values["APY"].uintValue = 100000;  
        _classes[6]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x560Ac248ce28972083B718778EEb0dbC2DE55740";
        emit classCreated(address(this), 6);

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
        _classes[6]._values["issuerDocURL"].stringValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/BR3.pdf"
        ];
        _classes[6]._values["fundType"].stringValue = "corporate";  
        _classes[6]._values["shareValue"].uintValue = 1;  
        _classes[6]._values["currency"].stringValue = "DAI";  

        _classes[6]._values["maxiumSupply"].uintValue = 4000000;  
        _classes[6]._values["callable"].boolValue = true;  
        _classes[6]._values["maturityPeriod"].uintValue = 322*60*60*24;  
        _classes[6]._values["coupon"].boolValue = true;  
        _classes[6]._values["couponRate"].uintValue = 11250;  
        _classes[6]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[6]._values["fixed-rate"].boolValue = false;  
        _classes[6]._values["APY"].uintValue = ;  
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
        _classes[7]._values["issuerDocURL"].stringValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/REIF1.pdf"
        ];
        _classes[7]._values["fundType"].stringValue = "corporate";  
        _classes[7]._values["shareValue"].uintValue = 1;  
        _classes[7]._values["currency"].stringValue = "DAI";  

        _classes[7]._values["maxiumSupply"].uintValue = 3000000;  
        _classes[7]._values["callable"].boolValue = true;  
        _classes[7]._values["maturityPeriod"].uintValue = 322*60*60*24;  
        _classes[7]._values["coupon"].boolValue = true;  
        _classes[7]._values["couponRate"].uintValue = 4166;  
        _classes[7]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[7]._values["fixed-rate"].boolValue = ture;  
        _classes[7]._values["APY"].uintValue = 50000;  
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
        _classes[8]._values["issuerDocURL"].stringValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/REIF1.pdf"
        ];
        _classes[8]._values["fundType"].stringValue = "corporate";  
        _classes[8]._values["shareValue"].uintValue = 1;  
        _classes[8]._values["currency"].stringValue = "DAI";  

        _classes[8]._values["maxiumSupply"].uintValue = 3000000;  
        _classes[8]._values["callable"].boolValue = true;  
        _classes[8]._values["maturityPeriod"].uintValue = 322*60*60*24;  
        _classes[8]._values["coupon"].boolValue = true;  
        _classes[8]._values["couponRate"].uintValue = 4166;  
        _classes[8]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[8]._values["fixed-rate"].boolValue = false;  
        _classes[8]._values["APY"].uintValue = 50000;  
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
        _classes[9]._values["issuerDocURL"].stringValue = [
            "https://docsend.com/view/s/gressukfmvcp6uip"
        ];
        _classes[9]._values["fundType"].stringValue = "corporate";  
        _classes[9]._values["shareValue"].uintValue = 1;  
        _classes[9]._values["currency"].stringValue = "DAI";  

        _classes[9]._values["maxiumSupply"].uintValue = 0;  
        _classes[9]._values["callable"].boolValue = true;  
        _classes[9]._values["maturityPeriod"].uintValue = 322*60*60*24;  
        _classes[9]._values["coupon"].boolValue = true;  
        _classes[9]._values["couponRate"].uintValue = 4166;  
        _classes[9]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[9]._values["fixed-rate"].boolValue = ture;  
        _classes[9]._values["APY"].uintValue = 50000;  
        _classes[9]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x4B6CA198d257D755A5275648D471FE09931b764A";
        emit classCreated(address(this), 9);

//////////////////////////////////////////////////////

        _classes[10]._values["symbol"].stringValue = "Fortunafi-Series 1 -Junior Loan";
        _classes[10]._values["category"].stringValue = "loan";
        _classes[10]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[10]._values["childCategory"].stringValue = "revenue based financing";
        
        _classes[10]._values["description"].stringValue = unicode"Fortunafi Asset Management is a technology enabled revenue based finance provider. Revenue based financing provides capital to small or growing businesses in return for a fixed percentage of ongoing gross revenues. Thus payments increase and decrease based on business revenues, typically measured as monthly revenue. Usually the returns to the investor continue until the initial capital amount, plus a multiple (also known as a cap) is repaid. This Tinlake pool is composed of a portfolio of revenue based financing agreements with an average maturity of twenty four months.";
        _classes[10]._values["issuerName"].stringValue = "Fortunafi";
        _classes[10]._values["issuerType"].stringValue = "LTD";
        _classes[10]._values["issuerJurisdiction"].stringValue = "US";
        _classes[10]._values["issuerURL"].stringValue = "https://www.fortunafi.com/";
        _classes[10]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Fortunafi.png";
        _classes[10]._values["issuerDocURL"].stringValue = [
            "https://docsend.com/view/s/gressukfmvcp6uip"
        ];
        _classes[10]._values["fundType"].stringValue = "corporate";  
        _classes[10]._values["shareValue"].uintValue = 1;  
        _classes[10]._values["currency"].stringValue = "DAI";  

        _classes[10]._values["maxiumSupply"].uintValue = 3100000;  
        _classes[10]._values["callable"].boolValue = true;  
        _classes[10]._values["maturityPeriod"].uintValue = 322*60*60*24;  
        _classes[10]._values["coupon"].boolValue = true;  
        _classes[10]._values["couponRate"].uintValue = 4166;  
        _classes[10]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[10]._values["fixed-rate"].boolValue = false;  
        _classes[10]._values["APY"].uintValue = 50000;  
        _classes[10]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x4B6CA198d257D755A5275648D471FE09931b764A";
        emit classCreated(address(this), 10);

////////////////////////////////////////////////////////

        _classes[11]._values["symbol"].stringValue = "BlockTower-Series 1 -Senior Loan";
        _classes[11]._values["category"].stringValue = "loan";
        _classes[11]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[11]._values["childCategory"].stringValue = "structured credit";
        
        _classes[11]._values["description"].stringValue = unicode"BlockTower Credit is the credit franchise of BlockTower Capital, an SEC-registered digital asset and blockchain investment firm founded in 2017. Within BlockTower Credit, we apply the skills of professional underwriting, structuring and investing at the intersection of real-world credit (a massive but anachronistic traditional industry) and crypto. This Tinlake Pool deploys capital into Structured Credit products will have an investment-grade rating and typically maintain a weighted average life (WAL) of less than four years. The Structured Credit products will generally fall into three major buckets: consumer ABS, auto ABS, and CLO.";
        _classes[11]._values["issuerName"].stringValue = "BlockTower";
        _classes[11]._values["issuerType"].stringValue = "LTD";
        _classes[11]._values["issuerJurisdiction"].stringValue = "US";
        _classes[11]._values["issuerURL"].stringValue = "https://www.blocktower.com/";
        _classes[11]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Blocktower.png";
        _classes[11]._values["issuerDocURL"].stringValue = [
            "https://storage.googleapis.com/tinlake/docs/summaries/BT1.pdf"
        ];
        _classes[11]._values["fundType"].stringValue = "corporate";  
        _classes[11]._values["shareValue"].uintValue = 1;  
        _classes[11]._values["currency"].stringValue = "DAI";  

        _classes[11]._values["maxiumSupply"].uintValue = 0;  
        _classes[11]._values["callable"].boolValue = true;  
        _classes[11]._values["maturityPeriod"].uintValue = 322*60*60*24;  
        _classes[11]._values["coupon"].boolValue = true;  
        _classes[11]._values["couponRate"].uintValue = 3333;  
        _classes[11]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[11]._values["fixed-rate"].boolValue = true;  
        _classes[11]._values["APY"].uintValue = 40000;  
        _classes[11]._values["subscribeLink"].stringValue = "https://app.centrifuge.io/pools/0x4597f91cC06687Bdb74147C80C097A79358Ed29b";
        emit classCreated(address(this), 11);



    }
   
}

