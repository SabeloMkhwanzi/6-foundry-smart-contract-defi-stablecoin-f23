// SPDX-License-Identifier: MIT

// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

pragma solidity 0.8.18;

import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/*
 * @title DecentralizedStableCoin
 * @author Sabelo MKhwanazi
 * The system is designed to be as minimal as possible, and have the token maintain a 1 token 1 == $1.00 pegged.
 * This project has the properties:
 * Exogenous Collateral
 * Dollar Pegged
 * Algorithmically Stable
 *
 * It similar to the DAI if DAI has no governance, no fees, and was only backed by WETH & WBTC.
 *
 * Our DSC system should always be "over collateralize". At no point, should the value of all collateral be <= the $value of all the DSC.
 *
 * This contract is the core of the DSC system. It handles all the logic for minting and redeeming DSC, as well as depositing & withdrawing collateral.
 * This contract is VERY loosely based on the MakerDAO DSS (DAI) system.
 */

contract DSCEngine is ReentrancyGuard {
    ////////////
    // Errors //
    //////////

    error DSCEngine__NeedsMoreThanZero();
    error DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
    error DSCEngine__NotAllowedToken();
    error DSCEngine__TransferFailed();

    //////////////////////
    // State variables //
    ////////////////////

    mapping(address => address) private s_priceFeeds;
    mapping(address user => mapping(address token => uint256 amount)) private s_collateralDeposited;
    mapping(address user => uint256 amountDscToMint) private s_DSCMinted;

    DecentralizedStableCoin private immutable i_dsc;
    ////////////////
    //  Events   //
    //////////////

    event CollateralDeposited(address indexed sender, address indexed token, uint256 indexed amount);

    ///////////////
    // Modifiers //
    //////////////

    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert DSCEngine__NeedsMoreThanZero();
        }
        _;
    }

    modifier isAllowedToken(address token) {
        if (s_priceFeeds[token] == address(0)) {
            revert DSCEngine__NotAllowedToken();
        }
        _;
    }

    ///////////////
    // Functions //
    //////////////

    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address dscAddress) {
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
        }

        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
        }

        i_dsc = DecentralizedStableCoin(dscAddress);
    }

    /////////////////////////
    // External functions //
    ///////////////////////
    /*
     * @notice follows CEI - Checks, Effects, and Interactions. 
     * @param tokenCollateralAddress: The ERC20 token address of the collateral you're depositing
     * @param amountCollateral: The amount of collateral you're depositing
     * @param amountDscToMint: The amount of DSC you want to mint
     * @notice This function will deposit your collateral and mint DSC in one transaction
     */
    function depositCollateralAndMintDsc() external {}

    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral)
        // Checks
        external
        moreThanZero(amountCollateral)
        isAllowedToken(tokenCollateralAddress)
        nonReentrant
    {
        // Effects
        s_collateralDeposited[msg.sender][tokenCollateralAddress] += amountCollateral;
        emit CollateralDeposited(msg.sender, tokenCollateralAddress, amountCollateral);
        // Internal interactions
        bool success = IERC20(tokenCollateralAddress).transferFrom(msg.sender, address(this), amountCollateral);
        if (!success) {
            revert DSCEngine__TransferFailed();
        }
    }

    function redeemCollateralForDsc() external {}

    function redeemCollateral() external {}

    /**
     * @notice follows CEI - Checks, Effects, and Interactions
     * @param amountDscToMint: The amount of DSC you want to mint
     * @notice This function will mint DSC
     * @notice This function will check if the collateral value > DSC amount, Price feeds, values, etc
     * @notice They must have more collateral than the minimum threshold
     */
    function mintDsc(uint256 amountDscToMint) external moreThanZero(amountDscToMint) nonReentrant {
        s_DSCMinted[msg.sender] += amountDscToMint;
        // check: if minted too much ($150 DSC, $100 ETH)

        revertIfHealthFactorIsBroken(msg.sender);
    }

    function burnDsc() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}

    ////////////////////////////////////////
    // Private & Internal View functions //
    /////////////////////////////////////
    /**
     * Returns how close to liquidation the user is.
     * If a user goes below 1, than they are in liquidation.
     */
    function _healthFactor(address user) private {
        //check: the following before: 1 Total DSC minted, 2 Total Collateral deposited.
    }

    function _revertIfHealthFactorIsBroken(address user) internal view {
        // Check: the following factor (do they have enough collateral?), 2. then revert.
    }
}
