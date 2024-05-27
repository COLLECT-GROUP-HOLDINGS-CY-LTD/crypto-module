// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(address owner, address spender)
    external
    view
    returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

library Address {
    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    function functionCall(address target, bytes memory data)
    internal
    returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
        functionCallWithValue(
            target,
            data,
            value,
            "Address: low-level call with value failed"
        );
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data)
    internal
    view
    returns (bytes memory)
    {
        return
        functionStaticCall(
            target,
            data,
            "Address: low-level static call failed"
        );
    }

    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data)
    internal
    returns (bytes memory)
    {
        return
        functionDelegateCall(
            target,
            data,
            "Address: low-level delegate call failed"
        );
    }

    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

library SafeERC20 {
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
    unchecked {
        uint256 oldAllowance = token.allowance(address(this), spender);
        require(
            oldAllowance >= value,
            "SafeERC20: decreased allowance below zero"
        );
        uint256 newAllowance = oldAllowance - value;
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }
    }

    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        bytes memory returndata = address(token).functionCall(
            data,
            "SafeERC20: low-level call failed"
        );
        if (returndata.length > 0) {
            // Return data is optional
            require(
                abi.decode(returndata, (bool)),
                "SafeERC20: ERC20 operation did not succeed"
            );
        }
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        require(initialOwner != address(0), "Invalid owner address");
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract MyWalletFactory is Ownable {
    mapping(address => bool) public isCreator;
    mapping(address => bool) public isManager;

    address[] public managers;
    address[] public creators;

    address[] public createdWallets;

    address public masterWallet;
    //address public sender;

    uint256 private nonce;

    event WalletCreated(address indexed wallet, uint256 idx);

    constructor(
        address initialOwner,
        address _master
    ) Ownable(initialOwner) {
        masterWallet = _master;
    }

    modifier onlyCreator() {
        require(
            isCreator[_msgSender()],
            "Caller is not allowed to create wallets"
        );
        _;
    }

    modifier managerExists(address manager) {
        require(
            isManager[manager],
            "Caller is not an authorized wallet"
        );
        _;
    }

    function addCreator(address account) external onlyOwner {
        require(
            !isCreator[account],
            "Account is already authorized to create wallets"
        );
        isCreator[account] = true;
        creators.push(account);
    }

    function removeCreator(address account) external onlyOwner {
        require(
            isCreator[account],
            "Account is not authorized to create wallets"
        );
        isCreator[account] = false;
        for (uint256 i = 0; i < creators.length; i++) {
            if (creators[i] == account) {
                creators[i] = creators[creators.length - 1];
                creators.pop();
                break;
            }
        }
    }

    function getCreators() public view returns (address[] memory) {
        return (creators);
    }

    function addToManagers(address account) external onlyOwner {
        require(
            !isManager[account],
            "Account is already authorized to be the manager"
        );
        require(!isManager[account] && account != address(0));
        isManager[account] = true;
        managers.push(account);
    }

    function removeFromManagers(address account) external onlyOwner {
        require(
            isManager[account],
            "Account is not authorized to be the manager"
        );
        require(isManager[account] && account != address(0));
        isManager[account] = false;
        for (uint256 i = 0; i < managers.length; i++) {
            if (managers[i] == account) {
                managers[i] = managers[managers.length - 1];
                managers.pop();
                break;
            }
        }
    }

    function getManagers() public view returns (address[] memory) {
        return (managers);
    }

    function setMasterWallet(address account) external onlyOwner {
        require(account != address(0), "Zero address not allowed");
        masterWallet = account;
    }

    function createWallet() public onlyCreator returns (address addr) {
        bytes memory bytecode = type(MyWallet).creationCode;
        nonce += 1;
        bytes32 salt = keccak256(
            abi.encodePacked(nonce, block.chainid, blockhash(block.number))
        );
        assembly {
            addr := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        createdWallets.push(addr);
        emit WalletCreated(addr, createdWallets.length - 1);
    }

    function batchCreateWallets(uint256 amount)
    public
    onlyCreator
    returns (address addr)
    {
        bytes memory bytecode = type(MyWallet).creationCode;
        for (uint256 i = 1; i <= amount; i++) {
            bytes32 salt = keccak256(
                abi.encodePacked(
                    nonce + i,
                    block.chainid,
                    blockhash(block.number)
                )
            );
            assembly {
                addr := create2(0, add(bytecode, 32), mload(bytecode), salt)
            }
            createdWallets.push(addr);
            emit WalletCreated(addr, createdWallets.length - 1);
        }
        nonce += amount;
    }

    function getCreatedWallets() public view returns (address[] memory) {
        return (createdWallets);
    }

    function walletsCount() public view returns (uint256) {
        return createdWallets.length;
    }

    function getWalletByIndex(uint256 idx) public view returns (address) {
        require(idx < createdWallets.length, "Invalid index");
        return createdWallets[idx];
    }

    function checkBalances(address _token, address[] memory _wallets)
    public
    view
    returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](_wallets.length);
        for (uint256 i = 0; i < _wallets.length; i++) {
            if (_token == address(0)) {
                result[i] = WalletInterface(_wallets[i]).getBalance();
            } else {
                result[i] = IERC20(_token).balanceOf(_wallets[i]);
            }
        }
        return result;
    }

    function resend(address _token, address[] memory _wallets)
    public
    managerExists(msg.sender)
    {
        for (uint256 i = 0; i < _wallets.length; i++) {
            if (_token == address(0)) {
                WalletInterface(_wallets[i]).resendETH();
            } else {
                WalletInterface(_wallets[i]).resendTokens(_token);
            }
        }
    }
}

interface FactoryInterface {
    function masterWallet() external view returns (address);

    function managers() external view returns (address[] memory);

    function creators() external view returns (address[] memory);
}

interface WalletInterface {
    function resendTokens(address token) external;

    function resendETH() external;

    function getBalance() external view returns (uint256);
}

contract MyWallet is Context {
    using SafeERC20 for IERC20;
    using Address for address;
    FactoryInterface private factory;

    constructor() {
        factory = FactoryInterface(msg.sender);
    }

    receive() external payable {}

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function resendTokens(address token) public {
        require(_msgSender() == address(factory), "Unauthorized access");
        uint256 balance = IERC20(token).balanceOf(address(this));
        if (balance > 0) {
            IERC20(token).safeTransfer(factory.masterWallet(), balance);
        }
    }

    function resendETH() public {
        require(_msgSender() == address(factory), "Unauthorized access");
        uint256 balance = address(this).balance;
        if (balance > 0) {
            payable(factory.masterWallet()).transfer(balance);
        }
    }
}
