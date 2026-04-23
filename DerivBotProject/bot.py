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
                
                print(f"✅ Trade Accepted at ${stake_value}")
                await asyncio.sleep(8)
                
                res = await api.statement({"limit": 1})
                p = res['statement']['transactions'][0]['amount']
                print(f"💰 Result: ${p}")

            except Exception as e:
                print(f"❌ Error: {e}")
                if "maximum purchase price" in str(e).lower():
                    print("💡 Server still blocking. Verify 'Trade' box at api.deriv.com")
                await asyncio.sleep(5)
    finally:
        await api.disconnect()

asyncio.run(start_bot())
