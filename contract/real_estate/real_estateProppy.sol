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
        
        _classes[1]._values["symbol"].stringValue = "3647 Brice Rd. Lot# 268, Zephyrhills, FL 33541, US - Lot #268";
        _classes[1]._values["category"].stringValue = "property";
        _classes[1]._values["subcategory"].stringValue = "Mobile home";
        _classes[1]._values["childCategory"].stringValue = "condominium";
        
        _classes[1]._values["description"].stringValue = unicode"55+/1985/2BD/1BA/700SQ FT/PARK FEES ONLY $560.00 INCLUDES WATER-SEWER-GARBAGE-LAWNCARE/FURNISHED/NEW FLORIDA ROOM-SECOND BEDROOM ADDITION/NEW RUBBER ROOF/NEW EXTRA LONG DRIVEWAY/NEW 8X10 STORAGE SHED/GAS RANGE-REFRIGERATOR-MICROWAFE ONLY 1-1/2 YEARS OLD/Whether you're looking for a snowbird "nest", full-time living, or just a great vacation property, this bungalow home is completely move-in ready and has lots of updates including addition of a Florida room/second bedroom. It's a roomy bonus space and opens to the main living area through a large doorway, giving a nice open feel to both areas. The kitchen has beautifully painted cabinetry, a great stamped metal backsplash, as well as sleek new door handles and drawer pulls for a really clean, modern feel. The appliances are just 1-1/2 years old and there is a four burner gas stove with heavy duty grates, rarely found in manufactured homes. The island bar offers an extra countertop area as well as room for seating on one side. The hallway leading to the main bedroom has an elevated double built-in closet with mirrored sliding doors and drawer storage below. The bath has larger single sink vanity with double door storage below and tub/shower combo. The main bedroom has a full-wall elevated closet with double mirrored sliding doors and large drawers below. There is a built-in chest of drawers as well as an over the bed built-in unit. The outdoor space boasts a stone front patio, large 8 x 10 storage shed, nice back yard, and extra long driveway. There is a lot packed into this well cared for home and it is all located in the charming pet friendly and people friendly 55+ community of Sweetwater in the heart of Zephyrhills and just 20 miles from Tampa. It offers a small town feel with all the advantages of the city. There are local restaurants, medical facilities, plenty of shopping, parks, golf courses, and fishing and with easy access to I-4 or I-75 you can reach the beach areas as well as the destination theme parks and all that the Orlando area has to offer in no time at all. Amenities include heated pool, billiards, library, shuffleboard, bingo, crafts, planned activities, and community events, all with a year round vacation vibe. If it's time for you to start a new chapter or adventure, you need to check this one out. It's move-in ready, priced to sell, and it will not last long, so call today to make an appointment for your showing!";
        _classes[1]._values["issuerName"].stringValue = "Propy";
        _classes[1]._values["issuerType"].stringValue = "LTD";
        _classes[1]._values["issuerJurisdiction"].stringValue = "US";
        _classes[1]._values["issuerURL"].stringValue = "https://propy.com/home/";
        _classes[1]._values["issuerLogo"].stringValue = "https://propy.com/home/static/media/propy-light-mode.c87a4988ad568844475e67e182195a07.svg";
        _classes[1]._values["issuerDocURL"].stringArrayValue = [
           ""
        ];

        _classes[1]._values["managerName"].stringValue = "Lori Manns";
        _classes[1]._values["managerType"].stringValue = "Person";
        _classes[1]._values["managerJurisdiction"].stringValue = "US";
        _classes[1]._values["managerURL"].stringValue = "https://propy.com/agent/649b81e0a82c2e9d18c924d3";
        _classes[1]._values["managerLogo"].stringValue = "";
        _classes[1]._values["managerDocURL"].stringArrayValue = [
            ""
        ];

        //pics of the property
        _classes[1]._values["cover"].stringArrayValue = [
            ""
        ];

        _classes[1]._values["propertyLocation"].stringValue = "Villa Marina 514, Playa Venao, Los Santos, Panama";
        _classes[1]._values["propertyLocationCoordinate"].stringValue = "7.425963,-80.185448";
        _classes[1]._values["propertySurface"].uintValue = 65;
        _classes[1]._values["propertyBedroom"].uintValue = 2;
        _classes[1]._values["propertyBathroom"].uintValue = 1;        
        _classes[1]._values["propertyRooms"].uintValue = 6;

        _classes[1]._values["fundType"].stringValue = "corporate";  
        _classes[1]._values["shareValue"].uintValue = 51;  
        _classes[1]._values["currency"].stringValue = "USD";  

        _classes[1]._values["maxiumSupply"].uintValue = 39500;  
        _classes[1]._values["maturityPeriod"].uintValue = 365*24*3600;  
        _classes[1]._values["fixed-rate"].boolValue = true;  
        _classes[1]._values["APR"].uintValue = 77572;  
        _classes[1]._values["ManagementFee"].uintValue = 16800;  
        _classes[1]._values["subscribeLink"].stringValue = "https://propy.com/property/64a76218bb65af435c1d4fb0";
        emit classCreated(address(this), 1);
   
    }

}
