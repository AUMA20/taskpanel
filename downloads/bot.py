import asyncio
from deriv_api import DerivAPI

# --- CONFIGURATION ---
# App ID 132104 has been verified with 'Trade' permissions
MY_APP_ID = '132104' 

# Use your newest token here (LFEbvxMs11TzSfp was the last provided)
MY_TOKEN = 'LFEbvxMs11TzSfp' 

async def run_bot():
    api = DerivAPI(app_id=MY_APP_ID)
    try:
        print("Connecting to Deriv...")
        await api.authorize(MY_TOKEN)
        print("Authorized Successfully!")

        while True:
            # Digit Over 5 Strategy - $0.35 Stake
            proposal = {
                "buy": 1,
                "price": 0.35,
                "parameters": {
                    "amount": 0.35,
                    "basis": "stake",
                    "contract_type": "DIGITOVER",
                    "currency": "USD",
                    "duration": 1,
                    "duration_unit": "t",
                    "barrier": "5",
                    "symbol": "1HZ100V"
                }
            }
            
            try:
                print("Sending Trade Request...")
                await api.buy(proposal)
                print("Trade placed!")
                
                # Wait for the tick result (10-12 seconds is safe)
                await asyncio.sleep(12)
                
                # Check results in the statement
                res = await api.statement({"limit": 1})
                profit = res['statement']['transactions'][0]['amount']
                print(f"Result: {profit}")
                
            except Exception as trade_err:
                print(f"Trade skipped: {trade_err}")
                await asyncio.sleep(5)

    except Exception as auth_err:
        print(f"Auth Error: {auth_err}")
        print("If 'Token is invalid', update the MY_TOKEN variable.")
    finally:
        await api.disconnect()

if __name__ == '__main__':
    asyncio.run(run_bot())
