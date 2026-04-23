def budget_calc():
    print("\n--- Project Rate Converter ---")
    try:
        usd = float(input("Enter amount in USD: "))
        rate = 129.50 
        total = usd * rate
        print(f"Total: KES {total:,.2f}")
    except ValueError:
        print("Please enter a number.")

if __name__ == "__main__":
    budget_calc()

