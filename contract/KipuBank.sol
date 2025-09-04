// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title KipuBank - Una bóveda descentralizada con límites de depósito y retiro.
/// @author Jorge Andrés Jácome
/// @notice Permite a los usuarios depositar y retirar ETH con límites y seguridad.
/// @dev Sigue buenas prácticas de seguridad, incluye errores personalizados y eventos.

contract KipuBank {
    // ============================
    // ======== EVENTS ===========
    // ============================

    /// @notice Se emite cuando un usuario realiza un depósito exitoso.
    /// @param user Dirección del usuario que depositó.
    /// @param amount Monto depositado.
    event DepositMade(address indexed user, uint256 amount);

    /// @notice Se emite cuando un usuario retira fondos exitosamente.
    /// @param user Dirección del usuario que retiró.
    /// @param amount Monto retirado.
    event WithdrawalMade(address indexed user, uint256 amount);

    // ============================
    // ======= ERRORS =============
    // ============================

    error MaxBankCapReached();
    error WithdrawLimitExceeded();
    error InsufficientBalance();
    error ZeroAmountNotAllowed();

    // ============================
    // ======== STATE =============
    // ============================

    /// @notice Límite de depósito global.
    uint256 public immutable bankCap;

    /// @notice Límite máximo por retiro.
    uint256 public immutable withdrawLimit;

    /// @notice Monto total depositado en el banco.
    uint256 public totalDeposited;

    /// @notice Mapeo que almacena los balances de cada usuario.
    mapping(address => uint256) private userVault;

    /// @notice Número de depósitos realizados.
    uint256 public depositCount;

    /// @notice Número de retiros realizados.
    uint256 public withdrawalCount;

    // ============================
    // ======== CONSTRUCTOR =======
    // ============================

    /// @param _bankCap Límite global de depósitos.
    /// @param _withdrawLimit Límite máximo de retiro por transacción.
    constructor(uint256 _bankCap, uint256 _withdrawLimit) {
        require(_bankCap > 0 && _withdrawLimit > 0, "Invalid initialization");
        bankCap = _bankCap;
        withdrawLimit = _withdrawLimit;
    }

    // ============================
    // ========= MODIFIER =========
    // ============================

    /// @notice Verifica que el monto enviado no sea cero.
    modifier nonZeroAmount(uint256 amount) {
        if (amount == 0) revert ZeroAmountNotAllowed();
        _;
    }

    // ============================
    // ========= DEPOSIT ==========
    // ============================

    /// @notice Permite depositar ETH a la bóveda personal del usuario.
    /// @dev Sigue el patrón checks-effects-interactions.
    /// @custom:external
    function deposit() external payable nonZeroAmount(msg.value) {
        if (totalDeposited + msg.value > bankCap) revert MaxBankCapReached();

        totalDeposited += msg.value;
        userVault[msg.sender] += msg.value;
        depositCount++;

        emit DepositMade(msg.sender, msg.value);
    }

    // ============================
    // ======== WITHDRAW ==========
    // ============================

    /// @notice Permite al usuario retirar una cantidad de su bóveda.
    /// @param amount Monto a retirar.
    /// @custom:external
    function withdraw(uint256 amount) external nonZeroAmount(amount) {
        if (amount > withdrawLimit) revert WithdrawLimitExceeded();
        if (userVault[msg.sender] < amount) revert InsufficientBalance();

        userVault[msg.sender] -= amount;
        totalDeposited -= amount;
        withdrawalCount++;

        // Transferencia segura
        _safeTransfer(msg.sender, amount);

        emit WithdrawalMade(msg.sender, amount);
    }

    // ============================
    // ======= PRIVATE FX =========
    // ============================

    /// @notice Realiza una transferencia segura de ETH.
    /// @param to Dirección del destinatario.
    /// @param amount Monto a enviar.
    function _safeTransfer(address to, uint256 amount) private {
        (bool success, ) = to.call{value: amount}("");
        require(success, "Transfer failed");
    }

    // ============================
    // ========= VIEW FX ==========
    // ============================

    /// @notice Devuelve el balance actual del usuario.
    /// @param user Dirección del usuario.
    /// @return balance del usuario.
    function getVaultBalance(address user) external view returns (uint256) {
        return userVault[user];
    }
}
