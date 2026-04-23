
            except Exception as e:
                print(f"⚠️ Trade Error: {e}")
                if "maximum purchase price" in str(e).lower():
                    print("🛑 Server is limiting this App ID. Try again in 15 mins.")
                    break
                await asyncio.sleep(3)

    finally:
        await api.disconnect()
        print("🔌 Disconnected safely.")

asyncio.run(start_bot())
EOF

python bot.py
pkill -f python
ps aux | grep python
cat <<EOF > bot.py
import asyncio
from deriv_api import DerivAPI

# --- CREDENTIALS ---
MY_APP_ID = '1089'
MY_TOKEN = 'XcrKw7Xnzcj60FP' 

# --- STRATEGY SETTINGS ---
INITIAL_STAKE = 0.35
MARTINGALE = 2.0
SYMBOL = '1HZ100V' 

async def start_bot():
    api = DerivAPI(app_id=MY_APP_ID)
    try:
        print("🔄 Connecting to Deriv...")
        await api.authorize(MY_TOKEN)
        print("🚀 SUCCESS: Session Active. Starting trades...")
        
        stake = INITIAL_STAKE
        contract_type = "DIGITOVER" 

        while True:
            print(f"--- Trading {contract_type} | Stake: \${stake} ---")
            try:
                await api.buy({
                    "price": stake,
                    "parameters": {
                        "amount": stake,
                        "basis": 'stake',
                        "contract_type": contract_type,
                        "currency": 'USD',
                        "duration": 1,
                        "duration_unit": 't',
                        "barrier": '5',
                        "symbol": SYMBOL
                    }
                })

                # Extended wait to avoid "Server Busy" errors
                await asyncio.sleep(7)
                
                res = await api.statement({"limit": 1, "description": 1})
                profit = float(res['statement']['transactions'][0]['amount'])

                if profit > 0:
                    print(f"✅ WIN! Profit: \${profit}. Resetting.")
                    stake = INITIAL_STAKE
                else:
                    new_stake = round(stake * MARTINGALE, 2)
                    print(f"❌ LOSS! Moving to \${new_stake}.")
                    stake = new_stake
                    contract_type = "DIGITUNDER" if contract_type == "DIGITOVER" else "DIGITOVER"

            except Exception as e:
                print(f"⚠️ Trade Error: {e}")
                if "maximum purchase price" in str(e).lower():
                    print("🛑 Server limit reached again. Resetting to \$0.35.")
                    stake = INITIAL_STAKE
                await asyncio.sleep(5)

    finally:
        await api.disconnect()

asyncio.run(start_bot())
EOF

python bot.py
pkill-f python
cat <<EOF > bot.py
import asyncio
from deriv_api import DerivAPI

# --- CREDENTIALS ---
MY_APP_ID = '1089'
MY_TOKEN = 'XcrKw7Xnzcj60FP' 

# --- STRATEGY SETTINGS ---
# Switching to Volatility 10 to bypass the block on Vol 100
INITIAL_STAKE = 0.35
MARTINGALE = 2.0
SYMBOL = 'R_10' 

async def start_bot():
    api = DerivAPI(app_id=MY_APP_ID)
    try:
        print("🔄 Connecting to new market (Volatility 10)...")
        await api.authorize(MY_TOKEN)
        print("🚀 SUCCESS: Authorized!")
        
        stake = INITIAL_STAKE
        contract_type = "DIGITOVER" 

        while True:
            print(f"--- Trading {contract_type} | Stake: \${stake} ---")
            try:
                await api.buy({
                    "price": stake,
                    "parameters": {
                        "amount": stake,
                        "basis": 'stake',
                        "contract_type": contract_type,
                        "currency": 'USD',
                        "duration": 1,
                        "duration_unit": 't',
                        "barrier": '5',
                        "symbol": SYMBOL
                    }
                })

                await asyncio.sleep(8) # Longer wait to keep server happy
                
                res = await api.statement({"limit": 1, "description": 1})
                profit = float(res['statement']['transactions'][0]['amount'])

                if profit > 0:
                    print(f"✅ WIN! Profit: \${profit}. Resetting.")
                    stake = INITIAL_STAKE
                else:
                    new_stake = round(stake * MARTINGALE, 2)
                    print(f"❌ LOSS! Moving to \${new_stake}.")
                    stake = new_stake
                    contract_type = "DIGITUNDER" if contract_type == "DIGITOVER" else "DIGITOVER"

            except Exception as e:
                print(f"⚠️ Error: {e}")
                if "maximum purchase price" in str(e).lower():
                    print("🛑 Volatility 10 is also limited. Resetting stake...")
                    stake = INITIAL_STAKE
                await asyncio.sleep(5)

    finally:
        await api.disconnect()

asyncio.run(start_bot())
EOF

python bot.py
pkill-if python
cat <<EOF > bot.py
import asyncio
from deriv_api import DerivAPI

# --- CREDENTIALS ---
MY_APP_ID = '1089'
MY_TOKEN = 'XcrKw7Xnzcj60FP' 

# --- STRATEGY SETTINGS ---
# Switching to Forex (EUR/USD) which has much higher stake limits
INITIAL_STAKE = 1.0
MARTINGALE = 2.0
SYMBOL = 'frxEURUSD' 

async def start_bot():
    api = DerivAPI(app_id=MY_APP_ID)
    try:
        print("🔄 Connecting to Forex Market (EUR/USD)...")
        await api.authorize(MY_TOKEN)
        print("🚀 SUCCESS: Authorized on Forex!")
        
        stake = INITIAL_STAKE
        # Note: Forex uses Rise/Fall (CALL/PUT) instead of Over/Under
        contract_type = "CALL" 

        while True:
            print(f"--- Trading {contract_type} | Stake: \${stake} ---")
            try:
                await api.buy({
                    "price": stake,
                    "parameters": {
                        "amount": stake,
                        "basis": 'stake',
                        "contract_type": contract_type,
                        "currency": 'USD',
                        "duration": 5,
                        "duration_unit": 'm',
                        "symbol": SYMBOL
                    }
                })

                await asyncio.sleep(10) # Safe delay for Forex trades
                
                res = await api.statement({"limit": 1, "description": 1})
                profit = float(res['statement']['transactions'][0]['amount'])

                if profit > 0:
                    print(f"✅ WIN! Profit: \${profit}. Resetting.")
                    stake = INITIAL_STAKE
                else:
                    new_stake = round(stake * MARTINGALE, 2)
                    print(f"❌ LOSS! Martingale to \${new_stake}.")
                    stake = new_stake
                    contract_type = "PUT" if contract_type == "CALL" else "CALL"

            except Exception as e:
                print(f"⚠️ Market Error: {e}")
                await asyncio.sleep(5)

    finally:
        await api.disconnect()

asyncio.run(start_bot())
EOF

python bot.py
cat <<EOF > bot.py
import asyncio
from deriv_api import DerivAPI

# --- CREDENTIALS ---
MY_APP_ID = '132104'
MY_TOKEN = 'XcrKw7Xnzcj60FP' 

# --- STRATEGY SETTINGS ---
INITIAL_STAKE = 0.35
MARTINGALE = 2.0
SYMBOL = 'R_50' # Trying Volatility 50 Index

async def start_bot():
    api = DerivAPI(app_id=MY_APP_ID)
    try:
        await api.authorize(MY_TOKEN)
        print("🚀 Authorized! Strategy: Digits on Volatility 50")
        
        stake = INITIAL_STAKE
        contract_type = "DIGITOVER" 

        while True:
            print(f"--- Trading {contract_type} | Stake: \${stake} ---")
            try:
                await api.buy({
                    "price": stake,
                    "parameters": {
                        "amount": stake,
                        "basis": 'stake',
                        "contract_type": contract_type,
                        "currency": 'USD',
                        "duration": 1,
                        "duration_unit": 't',
                        "barrier": '5',
                        "symbol": SYMBOL
                    }
                })

                await asyncio.sleep(10)
                
                res = await api.statement({"limit": 1})
                profit = float(res['statement']['transactions'][0]['amount'])

                if profit > 0:
                    print(f"✅ WIN! Resetting stake.")
                    stake = INITIAL_STAKE
                else:
                    print(f"❌ LOSS! Applying Martingale.")
                    stake = round(stake * MARTINGALE, 2)
                    contract_type = "DIGITUNDER" if contract_type == "DIGITOVER" else "DIGITOVER"

            except Exception as e:
                print(f"⚠️ Server Error: {e}")
                await asyncio.sleep(5)

    finally:
        await api.disconnect()

asyncio.run(start_bot())
EOF

python bot.py
cat <<EOF > bot.py
import asyncio
from deriv_api import DerivAPI

# --- CREDENTIALS ---
MY_APP_ID = '132104'
MY_TOKEN = 'XcrKw7Xnzcj60FP' 

# --- STRATEGY SETTINGS ---
INITIAL_STAKE = 0.35
MARTINGALE = 2.0
SYMBOL = '1HZ100V' 

async def start_bot():
    api = DerivAPI(app_id=MY_APP_ID)
    try:
        await api.authorize(MY_TOKEN)
        print("🚀 Authorized! Testing for Stake bug...")
        
        stake = INITIAL_STAKE
        contract_type = "DIGITOVER" 

        while True:
            # We use float() and round to ensure the API sees exactly 0.35
            current_stake = float(round(stake, 2))
            print(f"--- Trading {contract_type} | Stake: \${current_stake} ---")
            
            try:
                await api.buy({
                    "buy": 1,
                    "price": current_stake,
                    "parameters": {
                        "amount": current_stake,
                        "basis": 'stake',
                        "contract_type": contract_type,
                        "currency": 'USD',
                        "duration": 1,
                        "duration_unit": 't',
                        "barrier": '5',
                        "symbol": SYMBOL
                    }
                })

                await asyncio.sleep(6)
                
                res = await api.statement({"limit": 1})
                profit = float(res['statement']['transactions'][0]['amount'])

                if profit > 0:
                    print(f"✅ WIN! Resetting.")
                    stake = INITIAL_STAKE
                else:
                    stake = round(stake * MARTINGALE, 2)
                    print(f"❌ LOSS! New stake: \${stake}")
                    contract_type = "DIGITUNDER" if contract_type == "DIGITOVER" else "DIGITOVER"

            except Exception as e:
                print(f"⚠️ API Rejected Trade: {e}")
                # If it still fails, the App ID doesn't have "Trade" scope enabled
                await asyncio.sleep(5)

    finally:
        await api.disconnect()

asyncio.run(start_bot())
EOF

python bot.py
cat <<EOF > bot.py
import asyncio
from deriv_api import DerivAPI

# --- CREDENTIALS ---
MY_APP_ID = '132104'
MY_TOKEN = 'XcrKw7Xnzcj60FP' # <--- IF YOU MADE A NEW TOKEN, PASTE IT HERE!

# --- STRATEGY ---
INITIAL_STAKE = 0.35
SYMBOL = '1HZ100V' 

async def start_bot():
    api = DerivAPI(app_id=MY_APP_ID)
    try:
        await api.authorize(MY_TOKEN)
        print("🟢 Connection Healthy. Attempting trade...")
        
        while True:
            try:
                # Force the buy request
                buy = await api.buy({
                    "buy": 1,
                    "price": float(INITIAL_STAKE),
                    "parameters": {
                        "amount": float(INITIAL_STAKE),
                        "basis": 'stake',
                        "contract_type": 'DIGITOVER',
                        "currency": 'USD',
                        "duration": 1,
                        "duration_unit": 't',
                        "barrier": '5',
                        "symbol": SYMBOL
                    }
                })
                
                print(f"✅ Trade Placed! ID: {buy['buy']['contract_id']}")
                await asyncio.sleep(10)
                
                # Check for the win/loss in statement
                res = await api.statement({"limit": 1})
                p = res['statement']['transactions'][0]['amount']
                print(f"💰 Last Trade Result: \${p}")

            except Exception as e:
                # This will tell us EXACTLY why it stopped showing trades
                print(f"❌ LOG ERROR: {e}")
                if "Scope" in str(e):
                    print("💡 FIX: Your Token or App ID is missing 'Trade' permissions!")
                await asyncio.sleep(5)
    finally:
        await api.disconnect()

asyncio.run(start_bot())
EOF

python bot.py
import asyncio
from deriv_api import DerivAPI
# --- CREDENTIALS ---
MY_APP_ID = '132104'
# PASTE YOUR NEW "FULL ACCESS" TOKEN BELOW
MY_TOKEN = 'XcrKw7Xnzcj60FP' 
# --- STRATEGY ---
INITIAL_STAKE = 0.35
SYMBOL = '1HZ100V' 
async def start_bot():
asyncio.run(start_bot())
cat <<EOF > bot.py
import asyncio
from deriv_api import DerivAPI

# --- CREDENTIALS ---
MY_APP_ID = '132104'
MY_TOKEN = 'XcrKw7Xnzcj60FP' 

# --- STRATEGY ---
INITIAL_STAKE = 0.35
SYMBOL = '1HZ100V' 

async def start_bot():
    api = DerivAPI(app_id=MY_APP_ID)
    try:
        await api.authorize(MY_TOKEN)
        print("🟢 Connection Restored. Sending test trade...")
        
        while True:
            try:
                # Force formatting to prevent 'maximum price' errors
                stake_value = float(round(INITIAL_STAKE, 2))
                
                await api.buy({
                    "buy": 1,
                    "price": stake_value,
                    "parameters": {
                        "amount": stake_value,
                        "basis": 'stake',
                        "contract_type": 'DIGITOVER',
                        "currency": 'USD',
                        "duration": 1,
                        "duration_unit": 't',
                        "barrier": '5',
                        "symbol": SYMBOL
                    }
                })
                
                print(f"✅ Trade Accepted at \${stake_value}")
                await asyncio.sleep(8)
                
                res = await api.statement({"limit": 1})
                p = res['statement']['transactions'][0]['amount']
                print(f"💰 Result: \${p}")

            except Exception as e:
                print(f"❌ Error: {e}")
                if "maximum purchase price" in str(e).lower():
                    print("💡 Server still blocking. Verify 'Trade' box at api.deriv.com")
                await asyncio.sleep(5)
    finally:
        await api.disconnect()

asyncio.run(start_bot())
EOF

python bot.py
sshd
ssh -D 8080 -f -C -q -N localhost
ifconfig wlan0
ip addr show wlan0
pkg install iproute2
ip addr show wlan0
curl ifconfig.me/ip
pkg install privoxy
privoxy --no-daemon /data/data/com.termux/files/usr/etc/privoxy/config
pkg install tor
nano /data/data/com.termux/files/usr/etc/tor/torrc
tor
tor
privoxy --no-daemon /data/data/com.termux/files/usr/etc/privoxy/config
nano /data/data/com.termux/files/usr/etc/privoxy/config
pkill privoxy
privoxy --no-daemon /data/data/com.termux/files/usr/etc/privoxy/config
nano /data/data/com.termux/files/usr/etc/privoxy/config
pkill privoxy
privoxy --no-daemon /data/data/com.termux/files/usr/etc/privoxy/config
