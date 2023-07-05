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
         
        _classes[0]._values["custodianName"].stringValue = "Credix";
        _classes[0]._values["custodianType"].stringValue = "LTD";
        _classes[0]._values["custodianJurisdiction"].stringValue = "BE";
        _classes[0]._values["custodianURL"].stringValue = "https://credix.finance/";
        _classes[0]._values["custodianLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/credix.jpeg";
        
        _classes[1]._values["symbol"].stringValue = "Atria deal 2 -Super Senior Loan";
        _classes[1]._values["category"].stringValue = "loan";
        _classes[1]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[1]._values["childCategory"].stringValue = "asset-backed car loan";
        
        _classes[1]._values["description"].stringValue = unicode"Atria is a fintech company established in 2022 that offers specialized services in used-car loan facilitation in Mexico. The firm is steered by a seasoned management team that was previously part of Credito Real’s auto financing division. It operates on a B2B framework, providing support to used-car dealerships. The company has recorded robust performance since October 2022 with its transactions, which are backed by a singular credit fund in the Credix network. Notably, defaults have remained exceptionally low at just 0.3%. The credit fund is currently considering the divestment of the senior tranche in order to focus on risk-adjusted high-yield returns. The yield for the senior tranche is negotiable.";
        _classes[1]._values["issuerName"].stringValue = "Atria";
        _classes[1]._values["issuerType"].stringValue = "LTD";
        _classes[1]._values["issuerJurisdiction"].stringValue = "MX";
        _classes[1]._values["issuerURL"].stringValue = "https://atria.la/";
        _classes[1]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/atria.la.png";

        _classes[1]._values["fundType"].stringValue = "corporate";  
        _classes[1]._values["shareValue"].uintValue = 1;  
        _classes[1]._values["currency"].stringValue = "USDC";  

        _classes[1]._values["maxiumSupply"].uintValue = 1524693;  
        _classes[1]._values["callable"].boolValue = true;  
        _classes[1]._values["maturityPeriod"].uintValue = 103680000;  
        _classes[1]._values["coupon"].boolValue = true;  
        _classes[1]._values["couponRate"].uintValue = 8333;  
        _classes[1]._values["couponPeriod"].uintValue = 2592000;  
        _classes[1]._values["fixed-rate"].boolValue = true;  
        _classes[1]._values["APY"].uintValue = 100000;  
        _classes[1]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=7pTa26B4jHywCtb8kLwZvKEt9Lh1trsD1RWrGi3jMQ9k";
        emit classCreated(address(this), 1);

        _classes[2]._values["symbol"].stringValue = "Atria deal 2 -Junior Loan";
        _classes[2]._values["category"].stringValue = "loan";
        _classes[2]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[2]._values["childCategory"].stringValue = "asset-backed car loan";
        
        _classes[2]._values["description"].stringValue = unicode"Atria is a fintech company established in 2022 that offers specialized services in used-car loan facilitation in Mexico. The firm is steered by a seasoned management team that was previously part of Credito Real’s auto financing division. It operates on a B2B framework, providing support to used-car dealerships. The company has recorded robust performance since October 2022 with its transactions, which are backed by a singular credit fund in the Credix network. Notably, defaults have remained exceptionally low at just 0.3%. The credit fund is currently considering the divestment of the senior tranche in order to focus on risk-adjusted high-yield returns. The yield for the senior tranche is negotiable.";
        _classes[2]._values["issuerName"].stringValue = "Atria";
        _classes[2]._values["issuerType"].stringValue = "LTD";
        _classes[2]._values["issuerJurisdiction"].stringValue = "MX";
        _classes[2]._values["issuerURL"].stringValue = "https://atria.la/";
        _classes[2]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/atria.la.png";

        _classes[2]._values["fundType"].stringValue = "corporate";  
        _classes[2]._values["shareValue"].uintValue = 1;  
        _classes[2]._values["currency"].stringValue = "USDC";  

        _classes[2]._values["maxiumSupply"].uintValue = 381173;  
        _classes[2]._values["callable"].boolValue = true;  
        _classes[2]._values["maturityPeriod"].uintValue = 103680000;  
        _classes[2]._values["coupon"].boolValue = true;  
        _classes[2]._values["couponRate"].uintValue = 8333;  
        _classes[2]._values["couponPeriod"].uintValue = 2592000;  
        _classes[2]._values["fixed-rate"].boolValue = true;  
        _classes[2]._values["APY"].uintValue = 312000;  
        _classes[2]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=7pTa26B4jHywCtb8kLwZvKEt9Lh1trsD1RWrGi3jMQ9k";
        emit classCreated(address(this), 2);

        _classes[3]._values["symbol"].stringValue = "Atria deal 1 -Senior Loan";
        _classes[3]._values["category"].stringValue = "loan";
        _classes[3]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[3]._values["childCategory"].stringValue = "asset-backed car loan";
        
        _classes[3]._values["description"].stringValue = unicode"Atria is a fintech company established in 2022 that offers specialized services in used-car loan facilitation in Mexico. The firm is steered by a seasoned management team that was previously part of Credito Real’s auto financing division. It operates on a B2B framework, providing support to used-car dealerships. The company has recorded robust performance since October 2022 with its transactions, which are backed by a singular credit fund in the Credix network. Notably, defaults have remained exceptionally low at just 0.3%. The credit fund is currently considering the divestment of the senior tranche in order to focus on risk-adjusted high-yield returns. The yield for the senior tranche is negotiable.";
        _classes[3]._values["issuerName"].stringValue = "Atria";
        _classes[3]._values["issuerType"].stringValue = "LTD";
        _classes[3]._values["issuerJurisdiction"].stringValue = "MX";
        _classes[3]._values["issuerURL"].stringValue = "https://atria.la/";
        _classes[3]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/atria.la.png";

        _classes[3]._values["fundType"].stringValue = "corporate";  
        _classes[3]._values["shareValue"].uintValue = 1;  
        _classes[3]._values["currency"].stringValue = "USDC";  

        _classes[3]._values["maxiumSupply"].uintValue = 340000;  

        _classes[3]._values["callable"].boolValue = true;  
        _classes[3]._values["maturityPeriod"].uintValue = 1350*60*60*24;  
        _classes[3]._values["coupon"].boolValue = true;  
        _classes[3]._values["couponRate"].uintValue = 10000;  
        _classes[3]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[3]._values["fixed-rate"].boolValue = true;  
        _classes[3]._values["APY"].uintValue = 120000;  
        _classes[3]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=Awifc6wG8CLLZBrgi5pgcFhAiHvcm4qA8uAHfYufnVcT";
        emit classCreated(address(this), 3);

        _classes[4]._values["symbol"].stringValue = "Atria deal 1 -Junior Loan";
        _classes[4]._values["category"].stringValue = "loan";
        _classes[4]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[4]._values["childCategory"].stringValue = "asset-backed car loan";
        
        _classes[4]._values["description"].stringValue = unicode"Atria is a fintech company established in 2022 that offers specialized services in used-car loan facilitation in Mexico. The firm is steered by a seasoned management team that was previously part of Credito Real’s auto financing division. It operates on a B2B framework, providing support to used-car dealerships. The company has recorded robust performance since October 2022 with its transactions, which are backed by a singular credit fund in the Credix network. Notably, defaults have remained exceptionally low at just 0.3%. The credit fund is currently considering the divestment of the senior tranche in order to focus on risk-adjusted high-yield returns. The yield for the senior tranche is negotiable.";
        _classes[4]._values["issuerName"].stringValue = "Atria";
        _classes[4]._values["issuerType"].stringValue = "LTD";
        _classes[4]._values["issuerJurisdiction"].stringValue = "MX";
        _classes[4]._values["issuerURL"].stringValue = "https://atria.la/";
        _classes[4]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/atria.la.png";

        _classes[4]._values["fundType"].stringValue = "corporate";  
        _classes[4]._values["shareValue"].uintValue = 1;  
        _classes[4]._values["currency"].stringValue = "USDC";  

        _classes[4]._values["maxiumSupply"].uintValue = 211969;  
        _classes[4]._values["callable"].boolValue = true;  
        _classes[4]._values["maturityPeriod"].uintValue = 1350*60*60*24;  
        _classes[4]._values["coupon"].boolValue = true;  
        _classes[4]._values["couponRate"].uintValue = 13333;  
        _classes[4]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[4]._values["fixed-rate"].boolValue = true;  
        _classes[4]._values["APY"].uintValue = 160000;  
        _classes[4]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=Awifc6wG8CLLZBrgi5pgcFhAiHvcm4qA8uAHfYufnVcT";
        emit classCreated(address(this), 4);
///////////////////////////////////////////////////////////////////////

        _classes[5]._values["symbol"].stringValue = "Credmei - deal 1 -Junior Loan";
        _classes[5]._values["category"].stringValue = "loan";
        _classes[5]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[5]._values["childCategory"].stringValue = "invoice advance";
        
        _classes[5]._values["description"].stringValue = unicode"Founded in 2013, Credmei is a Brazilian fintech focused on short-term receivables advancing. The company is led by a seasoned management team with +40 years combined experience in the financial services and banking industries, and focuses on providing invoice discounting solutions for SMEs in Brazil. Their client base is composed of SME's from different segments, with a particular focus within the agribusiness and food industries.";
        _classes[5]._values["issuerName"].stringValue = "Credmei";
        _classes[5]._values["issuerType"].stringValue = "LTD";
        _classes[5]._values["issuerJurisdiction"].stringValue = "BR";
        _classes[5]._values["issuerURL"].stringValue = "https://credmei.com.br/";
        _classes[5]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Credmei.png";

        _classes[5]._values["fundType"].stringValue = "corporate";  
        _classes[5]._values["shareValue"].uintValue = 1;  
        _classes[5]._values["currency"].stringValue = "USDC";  

        _classes[5]._values["maxiumSupply"].uintValue = 131200;  
        _classes[5]._values["callable"].boolValue = true;  
        _classes[5]._values["maturityPeriod"].uintValue = 657*60*60*24;  
        _classes[5]._values["coupon"].boolValue = true;  
        _classes[5]._values["couponRate"].uintValue = 14166;  
        _classes[5]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[5]._values["fixed-rate"].boolValue = true;  
        _classes[5]._values["APY"].uintValue = 170000;  
        _classes[5]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=4oNn7SNY5y3fM8X1RhubMHScGbaynEEy4mM1nB8XBsUN";
        emit classCreated(address(this), 5);

///////////////////////////////////////////////////////////////////////

        _classes[6]._values["symbol"].stringValue = "Credmei - deal 1 -Senior Loan";
        _classes[6]._values["category"].stringValue = "loan";
        _classes[6]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[6]._values["childCategory"].stringValue = "invoice advance";
        
        _classes[6]._values["description"].stringValue = unicode"Founded in 2013, Credmei is a Brazilian fintech focused on short-term receivables advancing. The company is led by a seasoned management team with +40 years combined experience in the financial services and banking industries, and focuses on providing invoice discounting solutions for SMEs in Brazil. Their client base is composed of SME's from different segments, with a particular focus within the agribusiness and food industries.";
        _classes[6]._values["issuerName"].stringValue = "Credmei";
        _classes[6]._values["issuerType"].stringValue = "LTD";
        _classes[6]._values["issuerJurisdiction"].stringValue = "BR";
        _classes[6]._values["issuerURL"].stringValue = "https://credmei.com.br/";
        _classes[6]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Credmei.png";

        _classes[6]._values["fundType"].stringValue = "corporate";  
        _classes[6]._values["shareValue"].uintValue = 1;  
        _classes[6]._values["currency"].stringValue = "USDC";  

        _classes[6]._values["maxiumSupply"].uintValue = 524800;  
        _classes[6]._values["callable"].boolValue = true;  
        _classes[6]._values["maturityPeriod"].uintValue = 657*60*60*24;  
        _classes[6]._values["coupon"].boolValue = true;  
        _classes[6]._values["couponRate"].uintValue = 10000;  
        _classes[6]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[6]._values["fixed-rate"].boolValue = true;  
        _classes[6]._values["APY"].uintValue = 120000;  
        _classes[6]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=4oNn7SNY5y3fM8X1RhubMHScGbaynEEy4mM1nB8XBsUN";
        emit classCreated(address(this), 6);

///////////////////////////////////////////////////////////////////////

        _classes[7]._values["symbol"].stringValue = "Tivos - deal 2 -Junior Loan";
        _classes[7]._values["category"].stringValue = "loan";
        _classes[7]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[7]._values["childCategory"].stringValue = "industrial machinery leasing";
        
        _classes[7]._values["description"].stringValue = unicode"Tivos is one of the leading credit fintechs specialized in asset-leasing solutions for industrial machinery essential to the proper operation of SMEs in Mexico. They offer tailored solutions and competitive rates through a fully-digital user experience that allow a comprehensive and accurate risk analysis. Tivos also seeks to optimize their clients' operations in every way by providing them with necessary working tools for efficient resource allocation, increasing sales, profitability and cash flows.";
        _classes[7]._values["issuerName"].stringValue = "Tivos";
        _classes[7]._values["issuerType"].stringValue = "LTD";
        _classes[7]._values["issuerJurisdiction"].stringValue = "MX";
        _classes[7]._values["issuerURL"].stringValue = "https://www.tivos.mx/";
        _classes[7]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Tivos.png";

        _classes[7]._values["fundType"].stringValue = "corporate";  
        _classes[7]._values["shareValue"].uintValue = 1;  
        _classes[7]._values["currency"].stringValue = "USDC";  

        _classes[7]._values["maxiumSupply"].uintValue = 335724;  
        _classes[7]._values["callable"].boolValue = true;  
        _classes[7]._values["maturityPeriod"].uintValue = 840*60*60*24;  
        _classes[7]._values["coupon"].boolValue = true;  
        _classes[7]._values["couponRate"].uintValue = 12333;  
        _classes[7]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[7]._values["fixed-rate"].boolValue = true;  
        _classes[7]._values["APY"].uintValue = 148000;  
        _classes[7]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=R56vsKfy7da5Hrkqg3Wd4e89FKbFuKrJRKqVwRXSfya";
        emit classCreated(address(this), 7);

///////////////////////////////////////////////////////////////////////

        _classes[8]._values["symbol"].stringValue = "Tivos - deal 2 -Senior Loan";
        _classes[8]._values["category"].stringValue = "loan";
        _classes[8]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[8]._values["childCategory"].stringValue = "industrial machinery leasing";
        
        _classes[8]._values["description"].stringValue = unicode"Tivos is one of the leading credit fintechs specialized in asset-leasing solutions for industrial machinery essential to the proper operation of SMEs in Mexico. They offer tailored solutions and competitive rates through a fully-digital user experience that allow a comprehensive and accurate risk analysis. Tivos also seeks to optimize their clients' operations in every way by providing them with necessary working tools for efficient resource allocation, increasing sales, profitability and cash flows.";
        _classes[8]._values["issuerName"].stringValue = "Tivos";
        _classes[8]._values["issuerType"].stringValue = "LTD";
        _classes[8]._values["issuerJurisdiction"].stringValue = "MX";
        _classes[8]._values["issuerURL"].stringValue = "https://www.tivos.mx/";
        _classes[8]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Tivos.png";

        _classes[8]._values["fundType"].stringValue = "corporate";  
        _classes[8]._values["shareValue"].uintValue = 1;  
        _classes[8]._values["currency"].stringValue = "USDC";  

        _classes[8]._values["maxiumSupply"].uintValue = 1034750;  
        _classes[8]._values["callable"].boolValue = true;  
        _classes[8]._values["maturityPeriod"].uintValue = 840*60*60*24;  
        _classes[8]._values["coupon"].boolValue = true;  
        _classes[8]._values["couponRate"].uintValue = 9166;  
        _classes[8]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[8]._values["fixed-rate"].boolValue = true;  
        _classes[8]._values["APY"].uintValue = 110000;  
        _classes[8]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=R56vsKfy7da5Hrkqg3Wd4e89FKbFuKrJRKqVwRXSfya";
        emit classCreated(address(this), 8);

///////////////////////////////////////////////////////////////////////

        _classes[9]._values["symbol"].stringValue = "Clave - deal 1B -Mezzanine Loan";
        _classes[9]._values["category"].stringValue = "loan";
        _classes[9]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[9]._values["childCategory"].stringValue = "trade receivables";
        
        _classes[9]._values["description"].stringValue = unicode"Clave is a platform bringing credit and other financial solutions to people in Latin America. Through a JV with Liquitech - a DIAN authorized trade receivables origination platform -, they are capitalizing on Colombia's electronic invoice growth with an end-to-end digital platform.";
        _classes[9]._values["issuerName"].stringValue = "Clave";
        _classes[9]._values["issuerType"].stringValue = "LTD";
        _classes[9]._values["issuerJurisdiction"].stringValue = "CO";
        _classes[9]._values["issuerURL"].stringValue = "https://www.clave.com/";
        _classes[9]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Clave.png";

        _classes[9]._values["fundType"].stringValue = "corporate";  
        _classes[9]._values["shareValue"].uintValue = 1;  
        _classes[9]._values["currency"].stringValue = "USDC";  

        _classes[9]._values["maxiumSupply"].uintValue = 750000;  
        _classes[9]._values["callable"].boolValue = true;  
        _classes[9]._values["maturityPeriod"].uintValue = 221*60*60*24;  
        _classes[9]._values["coupon"].boolValue = true;  
        _classes[9]._values["couponRate"].uintValue = 9583;  
        _classes[9]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[9]._values["fixed-rate"].boolValue = true;  
        _classes[9]._values["APY"].uintValue = 115000;  
        _classes[9]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=BistWXZbsN24NmmThGYTLviKpRF4oNYNw5po6UkqNoyW";
        emit classCreated(address(this), 9);

///////////////////////////////////////////////////////////////////////

        _classes[10]._values["symbol"].stringValue = "Clave - deal 1B -Senior Loan";
        _classes[10]._values["category"].stringValue = "loan";
        _classes[10]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[10]._values["childCategory"].stringValue = "trade receivables";
        
        _classes[10]._values["description"].stringValue = unicode"Clave is a platform bringing credit and other financial solutions to people in Latin America. Through a JV with Liquitech - a DIAN authorized trade receivables origination platform -, they are capitalizing on Colombia's electronic invoice growth with an end-to-end digital platform.";
        _classes[10]._values["issuerName"].stringValue = "Clave";
        _classes[10]._values["issuerType"].stringValue = "LTD";
        _classes[10]._values["issuerJurisdiction"].stringValue = "CO";
        _classes[10]._values["issuerURL"].stringValue = "https://www.clave.com/";
        _classes[10]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Clave.png";

        _classes[10]._values["fundType"].stringValue = "corporate";  
        _classes[10]._values["shareValue"].uintValue = 1;  
        _classes[10]._values["currency"].stringValue = "USDC";  

        _classes[10]._values["maxiumSupply"].uintValue = 501652;  
        _classes[10]._values["callable"].boolValue = true;  
        _classes[10]._values["maturityPeriod"].uintValue = 221*60*60*24;  
        _classes[10]._values["coupon"].boolValue = true;  
        _classes[10]._values["couponRate"].uintValue = 9583;  
        _classes[10]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[10]._values["fixed-rate"].boolValue = true;  
        _classes[10]._values["APY"].uintValue = 115000;  
        _classes[10]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=BistWXZbsN24NmmThGYTLviKpRF4oNYNw5po6UkqNoyW";
        emit classCreated(address(this), 10);

////////////////////////////////////////////////////////////////////

        _classes[11]._values["symbol"].stringValue = "Clave - deal 1A -Unitranche Loan";
        _classes[11]._values["category"].stringValue = "loan";
        _classes[11]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[11]._values["childCategory"].stringValue = "trade receivables";
        
        _classes[11]._values["description"].stringValue = unicode"Clave is a platform bringing credit and other financial solutions to people in Latin America. Through a JV with Liquitech - a DIAN authorized trade receivables origination platform -, they are capitalizing on Colombia's electronic invoice growth with an end-to-end digital platform.";
        _classes[11]._values["issuerName"].stringValue = "Clave";
        _classes[11]._values["issuerType"].stringValue = "LTD";
        _classes[11]._values["issuerJurisdiction"].stringValue = "CO";
        _classes[11]._values["issuerURL"].stringValue = "https://www.clave.com/";
        _classes[11]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Clave.png";

        _classes[11]._values["fundType"].stringValue = "corporate";  
        _classes[11]._values["shareValue"].uintValue = 1;  
        _classes[11]._values["currency"].stringValue = "USDC";  

        _classes[11]._values["maxiumSupply"].uintValue = 749716;  
        _classes[11]._values["callable"].boolValue = true;  
        _classes[11]._values["maturityPeriod"].uintValue = 188*60*60*24;  
        _classes[11]._values["coupon"].boolValue = true;  
        _classes[11]._values["couponRate"].uintValue = 9583;  
        _classes[11]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[11]._values["fixed-rate"].boolValue = true;  
        _classes[11]._values["APY"].uintValue = 115000;  
        _classes[11]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=2tpDYF5C2TgaS3qeAmWVaM9rgRfE43wgcaZPrKRQB8dc";
        emit classCreated(address(this), 11);

////////////////////////////////////////////////////////////////////

        _classes[12]._values["symbol"].stringValue = "Tivos - deal 1 -Super Senior Loan";
        _classes[12]._values["category"].stringValue = "loan";
        _classes[12]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[12]._values["childCategory"].stringValue = "industrial machinery leasing";
        
        _classes[12]._values["description"].stringValue = unicode"Tivos is one of the leading credit fintechs specialized in asset-leasing solutions for industrial machinery essential to the proper operation of SMEs in Mexico. They offer tailored solutions and competitive rates through a fully-digital user experience that allow a comprehensive and accurate risk analysis. Tivos also seeks to optimize their clients' operations in every way by providing them with necessary working tools for efficient resource allocation, increasing sales, profitability and cash flows.";
        _classes[12]._values["issuerName"].stringValue = "Tivos";
        _classes[12]._values["issuerType"].stringValue = "LTD";
        _classes[12]._values["issuerJurisdiction"].stringValue = "MX";
        _classes[12]._values["issuerURL"].stringValue = "https://www.tivos.mx/";
        _classes[12]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Tivos.png";

        _classes[12]._values["fundType"].stringValue = "corporate";  
        _classes[12]._values["shareValue"].uintValue = 1;  
        _classes[12]._values["currency"].stringValue = "USDC";  

        _classes[12]._values["maxiumSupply"].uintValue = 1000000;  
        _classes[12]._values["callable"].boolValue = true;  
        _classes[12]._values["maturityPeriod"].uintValue = 833*60*60*24;  
        _classes[12]._values["coupon"].boolValue = true;  
        _classes[12]._values["couponRate"].uintValue = 10000;  
        _classes[12]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[12]._values["fixed-rate"].boolValue = true;  
        _classes[12]._values["APY"].uintValue = 120000;  
        _classes[12]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=DNqQT9oSAwCPY7U1n5AtAjkWkHGNxtzZjgVxk7kXFt9y";
        emit classCreated(address(this), 12);

///////////////////////////////////////////////////////////////

        _classes[13]._values["symbol"].stringValue = "Tivos - deal 1 -Junior Loan";
        _classes[13]._values["category"].stringValue = "loan";
        _classes[13]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[13]._values["childCategory"].stringValue = "industrial machinery leasing";
        
        _classes[13]._values["description"].stringValue = unicode"Tivos is one of the leading credit fintechs specialized in asset-leasing solutions for industrial machinery essential to the proper operation of SMEs in Mexico. They offer tailored solutions and competitive rates through a fully-digital user experience that allow a comprehensive and accurate risk analysis. Tivos also seeks to optimize their clients' operations in every way by providing them with necessary working tools for efficient resource allocation, increasing sales, profitability and cash flows.";
        _classes[13]._values["issuerName"].stringValue = "Tivos";
        _classes[13]._values["issuerType"].stringValue = "LTD";
        _classes[13]._values["issuerJurisdiction"].stringValue = "MX";
        _classes[13]._values["issuerURL"].stringValue = "https://www.tivos.mx/";
        _classes[13]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Tivos.png";

        _classes[13]._values["fundType"].stringValue = "corporate";  
        _classes[13]._values["shareValue"].uintValue = 1;  
        _classes[13]._values["currency"].stringValue = "USDC";  

        _classes[13]._values["maxiumSupply"].uintValue = 792405;  
        _classes[13]._values["callable"].boolValue = true;  
        _classes[13]._values["maturityPeriod"].uintValue = 833*60*60*24;  
        _classes[13]._values["coupon"].boolValue = true;  
        _classes[13]._values["couponRate"].uintValue = 11583;  
        _classes[13]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[13]._values["fixed-rate"].boolValue = true;  
        _classes[13]._values["APY"].uintValue = 139000;  
        _classes[13]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=DNqQT9oSAwCPY7U1n5AtAjkWkHGNxtzZjgVxk7kXFt9y";
        emit classCreated(address(this), 13);

///////////////////////////////////////////////////////////////

        _classes[14]._values["symbol"].stringValue = "Asaak - deal 1 -Senior Loan";
        _classes[14]._values["category"].stringValue = "loan";
        _classes[14]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[14]._values["childCategory"].stringValue = "ssset-backed motorcycle loan";
        
        _classes[14]._values["description"].stringValue = unicode"Asaak is a fintech providing asset-financing in Uganda. Founded in 2016, they have built a data-driven, end-to-end, loan origination platform that enables them to cater to SMEs and entrepreneurs traditionally underserved by mainstream financial institutions. Asaak finances motorcycles (known locally as “boda bodas”) via a lease-to-own model for fast-growing and lucrative business activities such as ride-sharing and delivery that require productive assets. Asaak’s diligent underwriting and robust risk model contributes to low NPLs despite significant growth in 2022. The deal is secured by Asaak’s loan receivables and cash.";
        _classes[14]._values["issuerName"].stringValue = "Asaak";
        _classes[14]._values["issuerType"].stringValue = "LTD";
        _classes[14]._values["issuerJurisdiction"].stringValue = "UG";
        _classes[14]._values["issuerURL"].stringValue = "https://www.asaak.com/";
        _classes[14]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/asaak.png";

        _classes[14]._values["fundType"].stringValue = "corporate";  
        _classes[14]._values["shareValue"].uintValue = 1;  
        _classes[14]._values["currency"].stringValue = "USDC";  

        _classes[14]._values["maxiumSupply"].uintValue = 1000000;  
        _classes[14]._values["callable"].boolValue = true;  
        _classes[14]._values["maturityPeriod"].uintValue = 585*60*60*24;  
        _classes[14]._values["coupon"].boolValue = true;  
        _classes[14]._values["couponRate"].uintValue = 10416;  
        _classes[14]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[14]._values["fixed-rate"].boolValue = true;  
        _classes[14]._values["APY"].uintValue = 125000;  
        _classes[14]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=DQtXYWVs4ttAq8uguMpTnpcEa2h1qaV48XdxjunciTzm";
        emit classCreated(address(this), 14);

///////////////////////////////////////////////////////////////

        _classes[15]._values["symbol"].stringValue = "Asaak - deal 1 -Junior Loan";
        _classes[15]._values["category"].stringValue = "loan";
        _classes[15]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[15]._values["childCategory"].stringValue = "ssset-backed motorcycle loan";
        
        _classes[15]._values["description"].stringValue = unicode"Asaak is a fintech providing asset-financing in Uganda. Founded in 2016, they have built a data-driven, end-to-end, loan origination platform that enables them to cater to SMEs and entrepreneurs traditionally underserved by mainstream financial institutions. Asaak finances motorcycles (known locally as “boda bodas”) via a lease-to-own model for fast-growing and lucrative business activities such as ride-sharing and delivery that require productive assets. Asaak’s diligent underwriting and robust risk model contributes to low NPLs despite significant growth in 2022. The deal is secured by Asaak’s loan receivables and cash.";
        _classes[15]._values["issuerName"].stringValue = "Asaak";
        _classes[15]._values["issuerType"].stringValue = "LTD";
        _classes[15]._values["issuerJurisdiction"].stringValue = "UG";
        _classes[15]._values["issuerURL"].stringValue = "https://www.asaak.com/";
        _classes[15]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/asaak.png";

        _classes[15]._values["fundType"].stringValue = "corporate";  
        _classes[15]._values["shareValue"].uintValue = 1;  
        _classes[15]._values["currency"].stringValue = "USDC";  

        _classes[15]._values["maxiumSupply"].uintValue = 500000;  
        _classes[15]._values["callable"].boolValue = true;  
        _classes[15]._values["maturityPeriod"].uintValue = 585*60*60*24;  
        _classes[15]._values["coupon"].boolValue = true;  
        _classes[15]._values["couponRate"].uintValue = 12916;  
        _classes[15]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[15]._values["fixed-rate"].boolValue = true;  
        _classes[15]._values["APY"].uintValue = 155000;  
        _classes[15]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=DQtXYWVs4ttAq8uguMpTnpcEa2h1qaV48XdxjunciTzm";
        emit classCreated(address(this), 15);

///////////////////////////////////////////////////////////////

        _classes[16]._values["symbol"].stringValue = "Lafin - deal 1 -Senior Loan";
        _classes[16]._values["category"].stringValue = "loan";
        _classes[16]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[16]._values["childCategory"].stringValue = "direct consumer loan";
        
        _classes[16]._values["description"].stringValue = unicode"Lafin is a microfinance company focused on providing direct consumer loans to the lower socioeconomic sectors of Mexico. They have 3 main products: individual loans, group loans and motorcycle loans (leasing). Since 2008, they've been dedicated to providing tailored credit and an exceptional customer experience to help people achieve their business goals. Initially focused on expanding through physical branches, in the last few years Lafín underwent a digital transformation and became omnichannel by creating a fully-digital user experience for requesting loans.";
        _classes[16]._values["issuerName"].stringValue = "Lafin";
        _classes[16]._values["issuerType"].stringValue = "LTD";
        _classes[16]._values["issuerJurisdiction"].stringValue = "MX";
        _classes[16]._values["issuerURL"].stringValue = "https://www.lafin.mx/";
        _classes[16]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Lafin.png";

        _classes[16]._values["fundType"].stringValue = "corporate";  
        _classes[16]._values["shareValue"].uintValue = 1;  
        _classes[16]._values["currency"].stringValue = "USDC";  

        _classes[16]._values["maxiumSupply"].uintValue = 487500;  
        _classes[16]._values["callable"].boolValue = true;  
        _classes[16]._values["maturityPeriod"].uintValue = 465*60*60*24;  
        _classes[16]._values["coupon"].boolValue = true;  
        _classes[16]._values["couponRate"].uintValue = 10000;  
        _classes[16]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[16]._values["fixed-rate"].boolValue = true;  
        _classes[16]._values["APY"].uintValue = 120000;  
        _classes[16]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=D6LbjpkisC8QcnBEpFgRiRN7QLT3CWx8FAWdM3dbQu5H";
        emit classCreated(address(this), 16);

////////////////////////////////////////////////////////

        _classes[17]._values["symbol"].stringValue = "Lafin - deal 1 -Junior Loan";
        _classes[17]._values["category"].stringValue = "loan";
        _classes[17]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[17]._values["childCategory"].stringValue = "direct consumer loan";
        
        _classes[17]._values["description"].stringValue = unicode"Lafin is a microfinance company focused on providing direct consumer loans to the lower socioeconomic sectors of Mexico. They have 3 main products: individual loans, group loans and motorcycle loans (leasing). Since 2008, they've been dedicated to providing tailored credit and an exceptional customer experience to help people achieve their business goals. Initially focused on expanding through physical branches, in the last few years Lafín underwent a digital transformation and became omnichannel by creating a fully-digital user experience for requesting loans.";
        _classes[17]._values["issuerName"].stringValue = "Lafin";
        _classes[17]._values["issuerType"].stringValue = "LTD";
        _classes[17]._values["issuerJurisdiction"].stringValue = "MX";
        _classes[17]._values["issuerURL"].stringValue = "https://www.lafin.mx/";
        _classes[17]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Lafin.png";

        _classes[17]._values["fundType"].stringValue = "corporate";  
        _classes[17]._values["shareValue"].uintValue = 1;  
        _classes[17]._values["currency"].stringValue = "USDC";  

        _classes[17]._values["maxiumSupply"].uintValue = 271994;  
        _classes[17]._values["callable"].boolValue = true;  
        _classes[17]._values["maturityPeriod"].uintValue = 465*60*60*24;  
        _classes[17]._values["coupon"].boolValue = true;  
        _classes[17]._values["couponRate"].uintValue = 12916;  
        _classes[17]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[17]._values["fixed-rate"].boolValue = true;  
        _classes[17]._values["APY"].uintValue = 155000;  
        _classes[17]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=D6LbjpkisC8QcnBEpFgRiRN7QLT3CWx8FAWdM3dbQu5H";
        emit classCreated(address(this), 17);

////////////////////////////////////////////////////////

        _classes[18]._values["symbol"].stringValue = "Adiante - deal 2 -Unitranche Loan";
        _classes[18]._values["category"].stringValue = "loan";
        _classes[18]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[18]._values["childCategory"].stringValue = "invoice advance";
        
        _classes[18]._values["description"].stringValue = unicode"Adiante is a Brazilian fintech specialized in discounting SME’s receivables by leveraging a proprietary AI-based underwriting algorithm. Founded by ex-Citibank Gustavo Blasco and part of GCB Group, a seasoned investments/capital markets holding, the company has been rapidly growing their loan origination (US$ 25m in 2021) at the same time as maintaining healthy NPL metrics. To support their growth, Adiante raised a US$ 1m with Credix in an off-balance Debenture structure.";
        _classes[18]._values["issuerName"].stringValue = "Adiante";
        _classes[18]._values["issuerType"].stringValue = "LTD";
        _classes[18]._values["issuerJurisdiction"].stringValue = "BR";
        _classes[18]._values["issuerURL"].stringValue = "https://adiantesa.com/";
        _classes[18]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/adiante-branca.png";

        _classes[18]._values["fundType"].stringValue = "corporate";  
        _classes[18]._values["shareValue"].uintValue = 1;  
        _classes[18]._values["currency"].stringValue = "USDC";  

        _classes[18]._values["maxiumSupply"].uintValue = 1000000;  
        _classes[18]._values["callable"].boolValue = true;  
        _classes[18]._values["maturityPeriod"].uintValue = 512*60*60*24;  
        _classes[18]._values["coupon"].boolValue = true;  
        _classes[18]._values["couponRate"].uintValue = 11250;  
        _classes[18]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[18]._values["fixed-rate"].boolValue = true;  
        _classes[18]._values["APY"].uintValue = 135000;  
        _classes[18]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=CDa4HeY2GPJiSexhJbs1NENFBXrq5fXhcFjnURGxQmRH";
        emit classCreated(address(this), 18);

////////////////////////////////////////////////////////

        _classes[19]._values["symbol"].stringValue = "Tecredi - deal 5 -Senior Loan";
        _classes[19]._values["category"].stringValue = "loan";
        _classes[19]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[19]._values["childCategory"].stringValue = "asset-backed car loan";
        
        _classes[19]._values["description"].stringValue = unicode"Tecredi is a fintech providing auto-finance to used car buyers in Brazil. Bootstrapped by a seasoned management team with more than 11 years of experience with car-financing in the region, they built a strong network of partnerships with resellers and insurance companies, which, coupled with the all-asset pledge on the vehicles through a conservative LTV, contribute to their very healthy NPLs. Credix and Tecredi raised a US$ 3m deal in an off-balance Debenture structure to support their loan origination growth.";
        _classes[19]._values["issuerName"].stringValue = "Tecredi";
        _classes[19]._values["issuerType"].stringValue = "LTD";
        _classes[19]._values["issuerJurisdiction"].stringValue = "BR";
        _classes[19]._values["issuerURL"].stringValue = "https://www.tecredi.com.br/";
        _classes[19]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Tecredi.png";

        _classes[19]._values["fundType"].stringValue = "corporate";  
        _classes[19]._values["shareValue"].uintValue = 1;  
        _classes[19]._values["currency"].stringValue = "USDC";  

        _classes[19]._values["maxiumSupply"].uintValue = 2400000;  
        _classes[19]._values["callable"].boolValue = true;  
        _classes[19]._values["maturityPeriod"].uintValue = 834*60*60*24;  
        _classes[19]._values["coupon"].boolValue = true;  
        _classes[19]._values["couponRate"].uintValue = 9166;  
        _classes[19]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[19]._values["fixed-rate"].boolValue = true;  
        _classes[19]._values["APY"].uintValue = 110000;  
        _classes[19]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=BJSVoJa8oroKmay8iZAREktBjhBekEcqs7L6y6Xa7eeo";
        emit classCreated(address(this), 19);

////////////////////////////////////////////////////////

        _classes[20]._values["symbol"].stringValue = "Tecredi - deal 5 -Junior Loan";
        _classes[20]._values["category"].stringValue = "loan";
        _classes[20]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[20]._values["childCategory"].stringValue = "asset-backed car loan";
        
        _classes[20]._values["description"].stringValue = unicode"Tecredi is a fintech providing auto-finance to used car buyers in Brazil. Bootstrapped by a seasoned management team with more than 11 years of experience with car-financing in the region, they built a strong network of partnerships with resellers and insurance companies, which, coupled with the all-asset pledge on the vehicles through a conservative LTV, contribute to their very healthy NPLs. Credix and Tecredi raised a US$ 3m deal in an off-balance Debenture structure to support their loan origination growth.";
        _classes[20]._values["issuerName"].stringValue = "Tecredi";
        _classes[20]._values["issuerType"].stringValue = "LTD";
        _classes[20]._values["issuerJurisdiction"].stringValue = "BR";
        _classes[20]._values["issuerURL"].stringValue = "https://www.tecredi.com.br/";
        _classes[20]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Tecredi.png";

        _classes[20]._values["fundType"].stringValue = "corporate";  
        _classes[20]._values["shareValue"].uintValue = 1;  
        _classes[20]._values["currency"].stringValue = "USDC";  

        _classes[20]._values["maxiumSupply"].uintValue = 600000;  
        _classes[20]._values["callable"].boolValue = true;  
        _classes[20]._values["maturityPeriod"].uintValue = 834*60*60*24;  
        _classes[20]._values["coupon"].boolValue = true;  
        _classes[20]._values["couponRate"].uintValue = 12083;  
        _classes[20]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[20]._values["fixed-rate"].boolValue = true;  
        _classes[20]._values["APY"].uintValue = 145000;  
        _classes[20]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=BJSVoJa8oroKmay8iZAREktBjhBekEcqs7L6y6Xa7eeo";
        emit classCreated(address(this), 20);

////////////////////////////////////////////////////////

        _classes[21]._values["symbol"].stringValue = "Tecredi - deal 4C -Unitranche Loan";
        _classes[21]._values["category"].stringValue = "loan";
        _classes[21]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[21]._values["childCategory"].stringValue = "asset-backed car loan";
        
        _classes[21]._values["description"].stringValue = unicode"Tecredi is a fintech providing auto-finance to used car buyers in Brazil. Bootstrapped by a seasoned management team with more than 11 years of experience with car-financing in the region, they built a strong network of partnerships with resellers and insurance companies, which, coupled with the all-asset pledge on the vehicles through a conservative LTV, contribute to their very healthy NPLs. Credix and Tecredi raised a US$ 3m deal in an off-balance Debenture structure to support their loan origination growth.";
        _classes[21]._values["issuerName"].stringValue = "Tecredi";
        _classes[21]._values["issuerType"].stringValue = "LTD";
        _classes[21]._values["issuerJurisdiction"].stringValue = "BR";
        _classes[21]._values["issuerURL"].stringValue = "https://www.tecredi.com.br/";
        _classes[21]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Tecredi.png";

        _classes[21]._values["fundType"].stringValue = "corporate";  
        _classes[21]._values["shareValue"].uintValue = 1;  
        _classes[21]._values["currency"].stringValue = "USDC";  

        _classes[21]._values["maxiumSupply"].uintValue = 895000;  
        _classes[21]._values["callable"].boolValue = true;  
        _classes[21]._values["maturityPeriod"].uintValue = 731*60*60*24;  
        _classes[21]._values["coupon"].boolValue = true;  
        _classes[21]._values["couponRate"].uintValue = 10500;  
        _classes[21]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[21]._values["fixed-rate"].boolValue = true;  
        _classes[21]._values["APY"].uintValue = 126000;  
        _classes[21]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=dv95jonwMSgRA5hWvzr5vNH1AGHL2d8UC5mMPb5sfcg";
        emit classCreated(address(this), 21);

////////////////////////////////////////////////////////

        _classes[22]._values["symbol"].stringValue = "Tecredi - deal 4B -Unitranche Loan";
        _classes[22]._values["category"].stringValue = "loan";
        _classes[22]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[22]._values["childCategory"].stringValue = "asset-backed car loan";
        
        _classes[22]._values["description"].stringValue = unicode"Tecredi is a fintech providing auto-finance to used car buyers in Brazil. Bootstrapped by a seasoned management team with more than 11 years of experience with car-financing in the region, they built a strong network of partnerships with resellers and insurance companies, which, coupled with the all-asset pledge on the vehicles through a conservative LTV, contribute to their very healthy NPLs. Credix and Tecredi raised a US$ 3m deal in an off-balance Debenture structure to support their loan origination growth.";
        _classes[22]._values["issuerName"].stringValue = "Tecredi";
        _classes[22]._values["issuerType"].stringValue = "LTD";
        _classes[22]._values["issuerJurisdiction"].stringValue = "BR";
        _classes[22]._values["issuerURL"].stringValue = "https://www.tecredi.com.br/";
        _classes[22]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Tecredi.png";

        _classes[22]._values["fundType"].stringValue = "corporate";  
        _classes[22]._values["shareValue"].uintValue = 1;  
        _classes[22]._values["currency"].stringValue = "USDC";  

        _classes[22]._values["maxiumSupply"].uintValue = 1000000;  
        _classes[22]._values["callable"].boolValue = true;  
        _classes[22]._values["maturityPeriod"].uintValue = 719*60*60*24;  
        _classes[22]._values["coupon"].boolValue = true;  
        _classes[22]._values["couponRate"].uintValue = 10500;  
        _classes[22]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[22]._values["fixed-rate"].boolValue = true;  
        _classes[22]._values["APY"].uintValue = 126000;  
        _classes[22]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=3jhQLsqq8eY8r1yQPDVnonUBh598LN1AZcxAJYChxNhJ";
        emit classCreated(address(this), 22);

////////////////////////////////////////////////////////

        _classes[23]._values["symbol"].stringValue = "Tecredi - deal 4A -Unitranche Loan";
        _classes[23]._values["category"].stringValue = "loan";
        _classes[23]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[23]._values["childCategory"].stringValue = "asset-backed car loan";
        
        _classes[23]._values["description"].stringValue = unicode"Tecredi is a fintech providing auto-finance to used car buyers in Brazil. Bootstrapped by a seasoned management team with more than 11 years of experience with car-financing in the region, they built a strong network of partnerships with resellers and insurance companies, which, coupled with the all-asset pledge on the vehicles through a conservative LTV, contribute to their very healthy NPLs. Credix and Tecredi raised a US$ 3m deal in an off-balance Debenture structure to support their loan origination growth.";
        _classes[23]._values["issuerName"].stringValue = "Tecredi";
        _classes[23]._values["issuerType"].stringValue = "LTD";
        _classes[23]._values["issuerJurisdiction"].stringValue = "BR";
        _classes[23]._values["issuerURL"].stringValue = "https://www.tecredi.com.br/";
        _classes[23]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Tecredi.png";

        _classes[23]._values["fundType"].stringValue = "corporate";  
        _classes[23]._values["shareValue"].uintValue = 1;  
        _classes[23]._values["currency"].stringValue = "USDC";  

        _classes[23]._values["maxiumSupply"].uintValue = 105000;  
        _classes[23]._values["callable"].boolValue = true;  
        _classes[23]._values["maturityPeriod"].uintValue = 717*60*60*24;  
        _classes[23]._values["coupon"].boolValue = true;  
        _classes[23]._values["couponRate"].uintValue = 10500;  
        _classes[23]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[23]._values["fixed-rate"].boolValue = true;  
        _classes[23]._values["APY"].uintValue = 126000;  
        _classes[23]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=3FMwb7SbSnm3X7aSePyV9gpEYqDSwE7smNMNZoxSM4up";
        emit classCreated(address(this), 23);

////////////////////////////////////////////////////////

        _classes[24]._values["symbol"].stringValue = "Tecredi - deal 3 -Unitranche Loan";
        _classes[24]._values["category"].stringValue = "loan";
        _classes[24]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[24]._values["childCategory"].stringValue = "asset-backed car loan";
        
        _classes[24]._values["description"].stringValue = unicode"Tecredi is a fintech providing auto-finance to used car buyers in Brazil. Bootstrapped by a seasoned management team with more than 11 years of experience with car-financing in the region, they built a strong network of partnerships with resellers and insurance companies, which, coupled with the all-asset pledge on the vehicles through a conservative LTV, contribute to their very healthy NPLs. Credix and Tecredi raised a US$ 3m deal in an off-balance Debenture structure to support their loan origination growth.";
        _classes[24]._values["issuerName"].stringValue = "Tecredi";
        _classes[24]._values["issuerType"].stringValue = "LTD";
        _classes[24]._values["issuerJurisdiction"].stringValue = "BR";
        _classes[24]._values["issuerURL"].stringValue = "https://www.tecredi.com.br/";
        _classes[24]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Tecredi.png";

        _classes[24]._values["fundType"].stringValue = "corporate";  
        _classes[24]._values["shareValue"].uintValue = 1;  
        _classes[24]._values["currency"].stringValue = "USDC";  

        _classes[24]._values["maxiumSupply"].uintValue = 750000;  
        _classes[24]._values["callable"].boolValue = true;  
        _classes[24]._values["maturityPeriod"].uintValue = 667*60*60*24;  
        _classes[24]._values["coupon"].boolValue = true;  
        _classes[24]._values["couponRate"].uintValue = 10500;  
        _classes[24]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[24]._values["fixed-rate"].boolValue = true;  
        _classes[24]._values["APY"].uintValue = 126000;  
        _classes[24]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=EnMa4fdxLkHdTRdaqLbjVPSxLWvq9n68YzK8RYZWFuoP";
        emit classCreated(address(this), 24);

////////////////////////////////////////////////////////

        _classes[25]._values["symbol"].stringValue = "Tecredi - deal 2 -Unitranche Loan";
        _classes[25]._values["category"].stringValue = "loan";
        _classes[25]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[25]._values["childCategory"].stringValue = "asset-backed car loan";
        
        _classes[25]._values["description"].stringValue = unicode"Tecredi is a fintech providing auto-finance to used car buyers in Brazil. Bootstrapped by a seasoned management team with more than 11 years of experience with car-financing in the region, they built a strong network of partnerships with resellers and insurance companies, which, coupled with the all-asset pledge on the vehicles through a conservative LTV, contribute to their very healthy NPLs. Credix and Tecredi raised a US$ 3m deal in an off-balance Debenture structure to support their loan origination growth.";
        _classes[25]._values["issuerName"].stringValue = "Tecredi";
        _classes[25]._values["issuerType"].stringValue = "LTD";
        _classes[25]._values["issuerJurisdiction"].stringValue = "BR";
        _classes[25]._values["issuerURL"].stringValue = "https://www.tecredi.com.br/";
        _classes[25]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Tecredi.png";

        _classes[25]._values["fundType"].stringValue = "corporate";  
        _classes[25]._values["shareValue"].uintValue = 1;  
        _classes[25]._values["currency"].stringValue = "USDC";  

        _classes[25]._values["maxiumSupply"].uintValue = 750000;  
        _classes[25]._values["callable"].boolValue = true;  
        _classes[25]._values["maturityPeriod"].uintValue = 626*60*60*24;  
        _classes[25]._values["coupon"].boolValue = true;  
        _classes[25]._values["couponRate"].uintValue = 10500;  
        _classes[25]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[25]._values["fixed-rate"].boolValue = true;  
        _classes[25]._values["APY"].uintValue = 126000;  
        _classes[25]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=GAZv6Nivo8AcAc5bBYsdC8yvgwoJzUtMKNPr8RkgZtVX";
        emit classCreated(address(this), 25);

////////////////////////////////////////////////////////

        _classes[26]._values["symbol"].stringValue = "Divibank - deal 1 -Super Senior Loan";
        _classes[26]._values["category"].stringValue = "loan";
        _classes[26]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[26]._values["childCategory"].stringValue = "revenue-based financing";
        
        _classes[26]._values["description"].stringValue = unicode"Divibank is a data-driven financing platform that provides non-dilutive growth capital to digital businesses in Brazil. Founded by two ex-Goldman Sachs bankers, the company raised US$ 3.6m in a seed round with Maya Capital and BTV in early 2022. To continue growing their US$ 4m loan book, Divibank structured a US$ 5.5m debt facility led by NY-based specialized credit fund Almavest, in which the Credix platform participated as senior investor.";
        _classes[26]._values["issuerName"].stringValue = "Divibank";
        _classes[26]._values["issuerType"].stringValue = "LTD";
        _classes[26]._values["issuerJurisdiction"].stringValue = "BR";
        _classes[26]._values["issuerURL"].stringValue = "https://www.divibank.co/";
        _classes[26]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Divibank.png";

        _classes[26]._values["fundType"].stringValue = "corporate";  
        _classes[26]._values["shareValue"].uintValue = 1;  
        _classes[26]._values["currency"].stringValue = "USDC";  

        _classes[26]._values["maxiumSupply"].uintValue = 1500000;  
        _classes[26]._values["callable"].boolValue = true;  
        _classes[26]._values["maturityPeriod"].uintValue = 257*60*60*24;  
        _classes[26]._values["coupon"].boolValue = true;  
        _classes[26]._values["couponRate"].uintValue = 8750;  
        _classes[26]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[26]._values["fixed-rate"].boolValue = true;  
        _classes[26]._values["APY"].uintValue = 105000;  
        _classes[26]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=89xZFZ4LGo7obbTcSc4prY8sDPG5j9aBbkztZHrfYVJS";
        emit classCreated(address(this), 26);

////////////////////////////////////////////////////////

        _classes[27]._values["symbol"].stringValue = "Divibank - deal 1 -Senior Loan";
        _classes[27]._values["category"].stringValue = "loan";
        _classes[27]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[27]._values["childCategory"].stringValue = "revenue-based financing";
        
        _classes[27]._values["description"].stringValue = unicode"Divibank is a data-driven financing platform that provides non-dilutive growth capital to digital businesses in Brazil. Founded by two ex-Goldman Sachs bankers, the company raised US$ 3.6m in a seed round with Maya Capital and BTV in early 2022. To continue growing their US$ 4m loan book, Divibank structured a US$ 5.5m debt facility led by NY-based specialized credit fund Almavest, in which the Credix platform participated as senior investor.";
        _classes[27]._values["issuerName"].stringValue = "Divibank";
        _classes[27]._values["issuerType"].stringValue = "LTD";
        _classes[27]._values["issuerJurisdiction"].stringValue = "BR";
        _classes[27]._values["issuerURL"].stringValue = "https://www.divibank.co/";
        _classes[27]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Divibank.png";

        _classes[27]._values["fundType"].stringValue = "corporate";  
        _classes[27]._values["shareValue"].uintValue = 1;  
        _classes[27]._values["currency"].stringValue = "USDC";  

        _classes[27]._values["maxiumSupply"].uintValue = 1000000;  
        _classes[27]._values["callable"].boolValue = true;  
        _classes[27]._values["maturityPeriod"].uintValue = 257*60*60*24;  
        _classes[27]._values["coupon"].boolValue = true;  
        _classes[27]._values["couponRate"].uintValue = 8750;  
        _classes[27]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[27]._values["fixed-rate"].boolValue = true;  
        _classes[27]._values["APY"].uintValue = 105000;  
        _classes[27]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=89xZFZ4LGo7obbTcSc4prY8sDPG5j9aBbkztZHrfYVJS";
        emit classCreated(address(this), 27);

////////////////////////////////////////////////////////

        _classes[28]._values["symbol"].stringValue = "Divibank - deal 1 -Junior Loan";
        _classes[28]._values["category"].stringValue = "loan";
        _classes[28]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[28]._values["childCategory"].stringValue = "revenue-based financing";
        
        _classes[28]._values["description"].stringValue = unicode"Divibank is a data-driven financing platform that provides non-dilutive growth capital to digital businesses in Brazil. Founded by two ex-Goldman Sachs bankers, the company raised US$ 3.6m in a seed round with Maya Capital and BTV in early 2022. To continue growing their US$ 4m loan book, Divibank structured a US$ 5.5m debt facility led by NY-based specialized credit fund Almavest, in which the Credix platform participated as senior investor.";
        _classes[28]._values["issuerName"].stringValue = "Divibank";
        _classes[28]._values["issuerType"].stringValue = "LTD";
        _classes[28]._values["issuerJurisdiction"].stringValue = "BR";
        _classes[28]._values["issuerURL"].stringValue = "https://www.divibank.co/";
        _classes[28]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Divibank.png";

        _classes[28]._values["fundType"].stringValue = "corporate";  
        _classes[28]._values["shareValue"].uintValue = 1;  
        _classes[28]._values["currency"].stringValue = "USDC";  

        _classes[28]._values["maxiumSupply"].uintValue = 3000000;  
        _classes[28]._values["callable"].boolValue = true;  
        _classes[28]._values["maturityPeriod"].uintValue = 257*60*60*24;  
        _classes[28]._values["coupon"].boolValue = true;  
        _classes[28]._values["couponRate"].uintValue = 13750;  
        _classes[28]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[28]._values["fixed-rate"].boolValue = true;  
        _classes[28]._values["APY"].uintValue = 165000;  
        _classes[28]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=89xZFZ4LGo7obbTcSc4prY8sDPG5j9aBbkztZHrfYVJS";
        emit classCreated(address(this), 28);

////////////////////////////////////////////////////////

        _classes[29]._values["symbol"].stringValue = "A55 - deal 3 -Unitranche Loan";
        _classes[29]._values["category"].stringValue = "loan";
        _classes[29]._values["subcategory"].stringValue = "asset-backed loan";
        _classes[29]._values["childCategory"].stringValue = "revenue-based financing";
        
        _classes[29]._values["description"].stringValue = unicode"a55 specializes in Revenue Based Financing in Brazil and Mexico, using a proprietary data-science framework for underwriting. The company was founded by a seasoned team with previous experience working in notable TradFi firms, and completed their Series B funding round of US$ 16m in early 2022, led by Movil. Credix and a55 raised a US$ 5m deal in an off-balance Debenture structure to support their loan origination growth in Brazil.";
        _classes[29]._values["issuerName"].stringValue = "A55";
        _classes[29]._values["issuerType"].stringValue = "LTD";
        _classes[29]._values["issuerJurisdiction"].stringValue = "BR";
        _classes[29]._values["issuerURL"].stringValue = "https://www.divibank.co/";
        _classes[29]._values["issuerLogo"].stringValue = "https://raw.githubusercontent.com/Debond-Protocol/Debond-Database/main/logo/Divibank.png";

        _classes[29]._values["fundType"].stringValue = "corporate";  
        _classes[29]._values["shareValue"].uintValue = 1;  
        _classes[29]._values["currency"].stringValue = "USDC";  

        _classes[29]._values["maxiumSupply"].uintValue = 3000000;  
        _classes[29]._values["callable"].boolValue = true;  
        _classes[29]._values["maturityPeriod"].uintValue = 257*60*60*24;  
        _classes[29]._values["coupon"].boolValue = true;  
        _classes[29]._values["couponRate"].uintValue = 13750;  
        _classes[29]._values["couponPeriod"].uintValue = 30*60*60*24;  
        _classes[29]._values["fixed-rate"].boolValue = true;  
        _classes[29]._values["APY"].uintValue = 165000;  
        _classes[29]._values["subscribeLink"].stringValue = "https://app.credix.finance/credix-marketplace/show/?dealId=89xZFZ4LGo7obbTcSc4prY8sDPG5j9aBbkztZHrfYVJS";
        emit classCreated(address(this), 29);


    }
   
}

