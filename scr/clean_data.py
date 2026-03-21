# import pandas as pd

# def load_and_clean(path, save_clean_path=None):
#     df = pd.read_csv(path)
    
#     # Strip column names
#     df.columns = df.columns.str.strip()
    
#     # TotalCharges: ubah spasi kosong jadi NaN lalu numeric
#     if "TotalCharges" in df.columns:
#         df["TotalCharges"] = df["TotalCharges"].replace(" ", pd.NA)
#         df["TotalCharges"] = pd.to_numeric(df["TotalCharges"], errors="coerce")
    
#     # Isi missing TotalCharges dengan MonthlyCharges * tenure jika memungkinkan
#     if {"TotalCharges", "MonthlyCharges", "tenure"} <= set(df.columns):
#         mask = df["TotalCharges"].isna()
#         df.loc[mask, "TotalCharges"] = (
#             df.loc[mask, "MonthlyCharges"] * df.loc[mask, "tenure"]
#         ).fillna(0)
    
#     # Pastikan SeniorCitizen integer
#     if "SeniorCitizen" in df.columns:
#         df["SeniorCitizen"] = df["SeniorCitizen"].astype(int)
    
#     # Pilih kolom teks (object/string)
#     text_cols = df.select_dtypes(include=["object", "string"]).columns
    
#     # Trim whitespace & lowercase
#     df[text_cols] = df[text_cols].apply(lambda col: col.str.strip().str.lower())
    
#     # Konsistensi nilai 'No internet service' / 'No phone service' -> 'no'
#     df[text_cols] = df[text_cols].replace({
#         "no internet service": "no",
#         "no phone service": "no"
#     })
    
#     # Ubah kolom Yes/No ke 1/0
#     binary_cols = [
#         c for c in text_cols
#         if set(df[c].dropna().unique()) <= {"yes", "no"}
#     ]
#     for col in binary_cols:
#         df[col] = df[col].map({"yes": 1, "no": 0}).astype("Int64")  # gunakan Int64 agar bisa menampung NaN
    
#     # Simpan hasil jika path diberikan
#     if save_clean_path:
#         df.to_csv(save_clean_path, index=False)
#         print(f"Data cleaned saved to: {save_clean_path}")
    
#     return df



# import pandas as pd

# def load_and_clean(path, save_clean_path=None):
#     df = pd.read_csv(path)
    
#     # Strip column names
#     df.columns = df.columns.str.strip()
    
#     # Cleaning TotalCharges
#     if "TotalCharges" in df.columns:
#         df["TotalCharges"] = df["TotalCharges"].replace(" ", pd.NA)
#         df["TotalCharges"] = pd.to_numeric(df["TotalCharges"], errors="coerce")
        
#         # Hapus baris dengan TotalCharges NaN
#         df = df.dropna(subset=["TotalCharges"])
    
#     # Pastikan SeniorCitizen integer
#     if "SeniorCitizen" in df.columns:
#         df["SeniorCitizen"] = df["SeniorCitizen"].astype(int)
    
#     # Pilih kolom teks
#     text_cols = df.select_dtypes(include=["object", "string"]).columns
    
#     # Trim whitespace & lowercase
#     df[text_cols] = df[text_cols].apply(lambda col: col.str.strip().str.lower())
    
#     # Konsistensi label
#     df[text_cols] = df[text_cols].replace({
#         "no internet service": "no",
#         "no phone service": "no"
#     })
    
#     # Ubah Yes/No ke 1/0
#     binary_cols = [
#         c for c in text_cols
#         if set(df[c].dropna().unique()) <= {"yes", "no"}
#     ]
    
#     for col in binary_cols:
#         df[col] = df[col].map({"yes": 1, "no": 0}).astype("Int64")
    
#     # Simpan hasil jika path diberikan
#     if save_clean_path:
#         df.to_csv(save_clean_path, index=False)
#         print(f"Data cleaned saved to: {save_clean_path}")
    
#     return df


import pandas as pd

def load_and_clean(path, save_clean_path=None):
    df = pd.read_csv(path)

    # Strip column names
    df.columns = df.columns.str.strip()

    # Cleaning TotalCharges
    if "TotalCharges" in df.columns:

        df["TotalCharges"] = df["TotalCharges"].replace([" ", ""], pd.NA)
        df["TotalCharges"] = pd.to_numeric(df["TotalCharges"], errors="coerce")

        mask_nan = df["TotalCharges"].isna()

        # jumlah NaN
        print("Jumlah NaN di TotalCharges:", mask_nan.sum())

        # cek berapa yang tenure = 0
        mask_tenure0 = mask_nan & (df["tenure"] == 0)

        print("NaN dengan tenure = 0:", mask_tenure0.sum())
        print("NaN dengan tenure > 0:", (mask_nan & (df["tenure"] > 0)).sum())

        # isi 0 jika tenure = 0
        df.loc[mask_tenure0, "TotalCharges"] = 0

        # drop sisanya
        df = df.dropna(subset=["TotalCharges"])

    # Pastikan SeniorCitizen numeric -> boolean
    if "SeniorCitizen" in df.columns:
        df["SeniorCitizen"] = df["SeniorCitizen"].astype(int).astype(bool)

    # Pilih kolom teks
    text_cols = df.select_dtypes(include=["object", "string"]).columns

    # Trim whitespace & lowercase
    df[text_cols] = df[text_cols].apply(lambda col: col.str.strip().str.lower())

    # Konsistensi label
    df[text_cols] = df[text_cols].replace({
        "no internet service": "no",
        "no phone service": "no"
    })

    # Ubah Yes/No ke 1/0
    binary_cols = [
        c for c in text_cols
        if set(df[c].dropna().unique()) <= {"yes", "no"}
    ]

    for col in binary_cols:
        df[col] = df[col].map({"yes": 1, "no": 0}).astype("boolean")

    # Simpan hasil jika path diberikan
    if save_clean_path:
        df.to_csv(save_clean_path, index=False)
        print(f"Data cleaned saved to: {save_clean_path}")

    return df

if __name__ == "__main__":
    input_path = r"D:/Data_analyst/telco_churn_project/data/raw_data/Telco_Customer_Churn.csv"
    output_path = r"D:/Data_analyst/telco_churn_project/data/processed/Telco_Customer_Churn_Cleaned.csv"
    
    df = load_and_clean(input_path, save_clean_path=output_path)
    print("Done.")
