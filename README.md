# KipuBank

KipuBank es un contrato inteligente en Solidity que simula una bóveda bancaria personal para usuarios, con límites seguros de depósito y retiro. Este proyecto sigue buenas prácticas de seguridad, uso de errores personalizados y optimizaciones para eficiencia.

## 📍 Contrato desplegado

- 🔗 Dirección: [`0xA417072546D9EbDB5D11b575f7C30D97E18aEc16`](https://sepolia.etherscan.io/address/0xA417072546D9EbDB5D11b575f7C30D97E18aEc16#code)
- 🌐 Red: Sepolia Testnet
- 🧱 Compilado con: Solidity `0.8.24`
- ⚙️ Optimización: activada

---

## 🧠 Funcionalidades principales

- 💰 Los usuarios pueden **depositar ETH** en una bóveda personal.
- 💸 Los usuarios pueden **retirar ETH**, pero solo hasta un límite fijo por transacción.
- 🔐 El contrato aplica un **límite global de depósitos (`bankCap`)**.
- 🧾 Registra el **número total de depósitos y retiros**.
- 🗣️ Emite eventos al depositar y retirar.
- ⚠️ Usa **errores personalizados** (`MaxBankCapReached`, `WithdrawLimitExceeded`, etc.).
- 📊 Consulta de saldo por usuario (`getVaultBalance`).
- 🔒 Cumple con el patrón **checks-effects-interactions**.
- 🧪 Incluye funciones `external`, `view`, y `private`.

---

## 🔨 Despliegue

Este contrato fue desplegado en la testnet **Sepolia** con los siguientes parámetros:

```solidity
bankCap = 5000000000000 wei     // 0.000005 ETH
withdrawLimit = 500000000000 wei // 0.0000005 ETH
