# 🌐 Future Interns Token (FIT)


A custom ERC-20 token built using **Solidity** and **Foundry**, deployed on the **Sepolia Testnet**.  
This project is part of **my blockchain internship program**, designed to provide **real-world, hands-on experience** in developing, testing, and deploying smart contracts using **industry-standard tools and frameworks**.

Through this internship project, I explored and implemented:
- The **ERC-20 standard**, which defines how fungible tokens operate on the Ethereum blockchain.
- The **OpenZeppelin library**, to ensure secure and upgradeable smart contract development.
- The **Foundry framework**, for compiling, testing, and deploying Solidity projects with advanced scripting support.
- The use of **test networks (Sepolia)**, enabling safe deployment and interaction with smart contracts without real ETH.
- **Version control (Git & GitHub)**, to manage source code, scripts, and documentation professionally.

The goal of this project is to **simulate real-world token development**, strengthen understanding of **blockchain fundamentals**, and demonstrate **smart contract lifecycle management** — from writing and testing to deploying and verifying contracts on a public testnet.


---

## 📋 Token Details

| Property | Value |
|-----------|--------|
| **Name** | Future Interns Token |
| **Symbol** | FIT |
| **Decimals** | 18 |
| **Total Supply** | 10,000,000 FIT (100M max cap) |
| **Contract Address** | `0xAe496077de4F14263f1873BbB276D670b2bD783c` |
| **Network** | Sepolia Testnet |

---

## 🚀 Quick Start

### 1️⃣ Install Foundry

Foundry is a blazing-fast, Rust-based Ethereum development framework.

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

---

### 2️⃣ Setup Project

Clone the repository and navigate to the token creation task:

```bash
git clone https://github.com/Code-Ove/FUTURE_BC_01.git
cd FUTURE_BC_01/Task2_Token_Creation
```

Install required dependencies:

```bash
forge install OpenZeppelin/openzeppelin-contracts --no-commit
forge install foundry-rs/forge-std --no-commit
```

---

### 3️⃣ Build & Test

Compile the contracts:
```bash
forge build
```

Run tests:
```bash
forge test
```

---

### 4️⃣ Deploy to Sepolia

Use your environment variables (`.env`) for private key and RPC URL.

```bash
forge script script/DeployToken.s.sol:DeployFutureInternsToken     --rpc-url $SEPOLIA_RPC_URL     --broadcast -vvvv
```

---

## 🔧 Features

✅ **ERC-20 Compliant** — Standard token interface  
✅ **Mintable & Burnable** — Owner can mint or burn tokens  
✅ **Account Freezing** — Admins can freeze malicious accounts  
✅ **Gasless Approvals** — Users can approve without direct gas spending  
✅ **Owner Controls** — Secure ownership and access control via modifiers  

---

## 📁 Project Structure

```
Task2_Token_Creation/
├── src/           # Smart contracts (FIT Token)
├── script/        # Deployment scripts
├── test/          # Test suite
├── lib/           # Installed dependencies
└── foundry.toml   # Foundry configuration file
```

---

## 🧠 Learnings

This project helps you understand:
- ERC-20 token standards and implementation
- Token deployment using Foundry scripts
- Environment-based deployment configuration
- OpenZeppelin library integration
- Best practices for secure smart contracts

---

## 🤝 Contributing

Pull requests and improvements are welcome!  
If you find a bug or want to suggest a feature, feel free to open an issue.

---

## 🪙 License

This project is licensed under the **MIT License**.  
See the [LICENSE](LICENSE) file for details.

---

### 👨‍💻 Developed by [Om Verma](https://github.com/Code-Ove)
> *Future Interns Blockchain Program – Task 2: Token Creation (Internship Project)*
