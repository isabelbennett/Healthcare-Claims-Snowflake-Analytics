import datetime as dt
import streamlit as st
import pandas as pd

# Set page config
st.set_page_config(
    page_title="CHIPMUNK Project Dashboard",
    layout="wide"
)

st.markdown("""
<style>
.dashboard-title {
    text-align: center;
    font-size: 2.4rem;
    font-weight: 800;
    margin-bottom: 1.4rem;
    color: #2f2f2f;
    letter-spacing: 0.3px;
}

.metric-card {
    padding: 1.1rem 1.1rem 1rem 1.1rem;
    border-radius: 24px;
    color: white;
    min-height: 190px;
    box-shadow: 0 10px 24px rgba(0,0,0,0.10);
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    text-align: left;
}

.metric-title {
    font-size: 0.8rem;
    font-weight: 700;
    line-height: 1.25;
    margin-bottom: 1.2rem;
}

.metric-label {
    font-size: 0.65rem;
    font-weight: 600;
    opacity: 0.82;
    text-transform: uppercase;
    letter-spacing: 0.6px;
    margin-bottom: 0.35rem;
}

.metric-value {
    font-size: 1.6rem;
    font-weight: 800;
    line-height: 1;
    margin-top: 0.1rem;
}

div[data-testid="stHorizontalBlock"] > div {
    align-self: stretch;
}

div[data-testid="stButton"] button {
    border-radius: 999px;
    min-height: 2rem;
    padding: 0.15rem 0.5rem;
}
</style>
""", unsafe_allow_html=True)

# Title
st.markdown(
    '<div class="dashboard-title">CHIPMUNK Project Dashboard</div>',
    unsafe_allow_html=True
)


# Initialize session configured for generated Streamlit apps
session = st.connection("snowflake").session()
try:
  session.query_tag = "__generated_streamlit"
except Exception:
  pass

@st.cache_data(ttl="23h50m")
def execute_query(query: str) -> str:
  return session.sql(query).collect_nowait().query_id


# Block one
def query_1_1() -> str:
  sql_query = r"""
SELECT COUNT(*) AS TOTAL_CLAIMS
FROM CHIPMUNK_CURATION.CUR_RX_WEEKLY;  """

  return sql_query

execute_query(query_1_1())

def colored_metric_card(title: str, value: str, color: str):
    st.markdown(
        f"""
        <div class="metric-card" style="background:{color};">
            <div class="metric-title">{title}</div>
            <div class="metric-value">{value}</div>
        </div>
        """,
        unsafe_allow_html=True
    )

@st.fragment
def cell_1_1():
    with st.container():
        with st.container(horizontal=True, horizontal_alignment="distribute", vertical_alignment="center"):
            with st.container(height=20, border=False):
                st.markdown("")
            if st.button(
                ":material/refresh:",
                type="tertiary",
                key="refresh_button_cell_1_1",
                help="Refresh total_claims data"
            ):
                execute_query.clear(query_1_1())

        try:
            with st.spinner("Executing query", show_time=True):
                df = session.create_async_job(
                    execute_query(query_1_1())
                ).result("pandas")

            if any(df.columns.duplicated()):
                new_names = []
                name_indexes = {}
                for name in df.columns:
                    name_index = name_indexes.get(name, 0) + 1
                    name_indexes[name] = name_index
                    new_names.append(f"{name}_{name_index}" if name_index > 1 else name)
                df.columns = new_names  

            if len(df) > 0:
                value = df["TOTAL_CLAIMS"].iloc[0]
                colored_metric_card(
                    title="Total Claims",
                    value=f"{value:,.0f}",
                    color="#7A2831"
                )
            else:
                st.warning("No data available")

        except Exception as e:
            st.error(f"Error: {str(e)}")

## Block two
def query_1_2() -> str:
  sql_query = r"""
SELECT AVG(TOTAL_MEMBER_PAID) AS AVG_MEMBER_PAID
FROM CHIPMUNK_CURATION.CUR_RX_WEEKLY
WHERE TOTAL_MEMBER_PAID >= 0;  """

  return sql_query

execute_query(query_1_2())

@st.fragment
def cell_1_2():
  with st.container():
    with st.container(horizontal=True, horizontal_alignment="distribute", vertical_alignment="center"):
      with st.container(height=20, border=False):
        st.markdown("")
      if st.button(
        ":material/refresh:",
        type="tertiary",
        key="refresh_button_cell_1_2",
        help="Refresh average_member_paid data"
      ):
        execute_query.clear(query_1_2())
          
    try:
      with st.spinner("Executing query", show_time=True):
        df = session.create_async_job(
          execute_query(query_1_2())
        ).result("pandas")

      if any(df.columns.duplicated()):
        new_names = []
        name_indexes = {}
        for name in df.columns:
          name_index = name_indexes.get(name, 0) + 1
          name_indexes[name] = name_index
          new_names.append(f"{name}_{name_index}" if name_index > 1 else name)
        df.columns = new_names

      # Calculate metric for scorecard
      if len(df) > 0:
        value = df["AVG_MEMBER_PAID"].iloc[0]
        colored_metric_card(
          title="Avg Member Paid",
          value=f"${value:,.2f}",
          color="#8A5C3D"
        )
      else:
        st.warning("No data available")
    except Exception as e:
      st.error(f"Error: {str(e)}")

## Block 3
def query_1_3() -> str:
  sql_query = r"""
SELECT AVG(MEMBER_SAVINGS_PERCENT) AS AVG_SAVINGS_PERCENT
FROM CHIPMUNK_CURATION.CUR_RX_WEEKLY;  """

  return sql_query

execute_query(query_1_3())

@st.fragment
def cell_1_3():
  with st.container():
    with st.container(horizontal=True, horizontal_alignment="distribute", vertical_alignment="center"):
      with st.container(height=20, border=False):
        st.markdown("")
      if st.button(
        ":material/refresh:", 
          type="tertiary", 
          key=f"refresh_button_cell_1_3", 
          help="Refresh average_savings_percent data"
      ):
        execute_query.clear(query_1_3())

    try:
      with st.spinner("Executing query", show_time=True):
        df = session.create_async_job(
          execute_query(query_1_3())
        ).result("pandas")

      if any(df.columns.duplicated()):
        new_names = []
        name_indexes = {}
        for name in df.columns:
          name_index = name_indexes.get(name, 0) + 1
          name_indexes[name] = name_index
          new_names.append(f"{name}_{name_index}" if name_index > 1 else name)
        df.columns = new_names

      # Calculate metric for scorecard
      if len(df) > 0:
        value = df["AVG_SAVINGS_PERCENT"].iloc[0]
        colored_metric_card(
          title = "Avg Savings %",
          value=f"{value * 100:.1f}%",
          color = "#9D1F2D"
        )
      else:
        st.warning("No data available")
    except Exception as e:
      st.error(f"Error: {str(e)}")

## Block 4
def query_1_4() -> str:
  sql_query = r"""
SELECT AVG(DAYS_BETWEEN_FILL_AND_SUBMIT) AS AVG_DAYS_TO_SUBMIT
FROM CHIPMUNK_CURATION.CUR_RX_WEEKLY
WHERE IS_REVERSED_CLAIM = FALSE;  """

  return sql_query

execute_query(query_1_4())

@st.fragment
def cell_1_4():
  with st.container():
    with st.container(horizontal=True, horizontal_alignment="distribute", vertical_alignment="center"):
      with st.container(height=20, border=False):
        st.markdown("")
      if st.button(
        ":material/refresh:", 
          type="tertiary", 
          key=f"refresh_button_cell_1_4", 
          help="Refresh average_processing_time_(days) data"
      ):
        execute_query.clear(query_1_4())

    try:
      with st.spinner("Executing query", show_time=True):
        df = session.create_async_job(
          execute_query(query_1_4())
        ).result("pandas")

      if any(df.columns.duplicated()):
        new_names = []
        name_indexes = {}
        for name in df.columns:
          name_index = name_indexes.get(name, 0) + 1
          name_indexes[name] = name_index
          new_names.append(f"{name}_{name_index}" if name_index > 1 else name)
        df.columns = new_names

      # Calculate metric for scorecard
      if len(df) > 0:
        value = df["AVG_DAYS_TO_SUBMIT"].iloc[0]
        colored_metric_card(
          title="Avg Processing Time",
          value=f"{value:,.0f}" + " Day(s)",
          color="#A7B8CF"
        )
      else:
        st.warning("No data available")
    except Exception as e:
      st.error(f"Error: {str(e)}")

# Row 1: 4 Cells
col1_1, col1_2, col1_3, col1_4 = st.columns(4)
with col1_1:
  cell_1_1()
with col1_2:
  cell_1_2()
with col1_3:
  cell_1_3()
with col1_4:
  cell_1_4()

def query_2_1() -> str:
  sql_query = r"""
SELECT COST_BURDEN_CATEGORY, TOTAL_CLAIMS
FROM AGG_COST_BURDEN_DISTRIBUTION
WHERE COST_BURDEN_CATEGORY <> 'Unknown'
ORDER BY TOTAL_CLAIMS DESC;  """

  return sql_query

execute_query(query_2_1())

@st.fragment
def cell_2_1():
  with st.container():
    with st.container(horizontal=True, horizontal_alignment="distribute", vertical_alignment="center"):
      with st.container(height=80, border=False, vertical_alignment="center"):
        st.markdown("### Number of Claims by Cost Burden Level")
      if st.button(
        ":material/refresh:", type="tertiary", key=f"refresh_button_cell_2_1", help="Refresh number_of_claims_by_cost_burden_level data"
      ):
        execute_query.clear(query_2_1())

    try:
      with st.spinner("Executing query", show_time=True):
        df = session.create_async_job(
          execute_query(query_2_1())
        ).result("pandas")

      if any(df.columns.duplicated()):
        new_names = []
        name_indexes = {}
        for name in df.columns:
          name_index = name_indexes.get(name, 0) + 1
          name_indexes[name] = name_index
          new_names.append(f"{name}_{name_index}" if name_index > 1 else name)
        df.columns = new_names

      # Prepare data for bar chart
      if len(df) > 0:
        df = df.groupby(
          by="COST_BURDEN_CATEGORY",
          sort=False
        ).agg(
          col1=("TOTAL_CLAIMS", "sum")
        ).rename(columns={
          "col1": "TOTAL_CLAIMS (sum)"
        }).reset_index()

        df["/* Order Key (Generated by Snowflake) */"] = df["COST_BURDEN_CATEGORY"]

        datetime_primary_column = None
        if pd.api.types.is_datetime64_dtype(df["COST_BURDEN_CATEGORY"]):
          datetime_primary_column = df["COST_BURDEN_CATEGORY"]
        elif df["COST_BURDEN_CATEGORY"].dtype == "object" and isinstance(df["COST_BURDEN_CATEGORY"].get(df["COST_BURDEN_CATEGORY"].first_valid_index()), dt.date):
          datetime_primary_column = pd.to_datetime(df["COST_BURDEN_CATEGORY"], errors="coerce")
        if datetime_primary_column is not None and (datetime_primary_column.max() - datetime_primary_column.min()).days > len(df) * 2:
          # Use string type for sparse date range
          df["COST_BURDEN_CATEGORY"] = df["COST_BURDEN_CATEGORY"].astype("string")

        st.bar_chart(
          df,
          x="COST_BURDEN_CATEGORY",
          y=[c for c in df.columns if c != "COST_BURDEN_CATEGORY" and c != "/* Order Key (Generated by Snowflake) */"],
          sort="-/* Order Key (Generated by Snowflake) */",
          use_container_width=True,
          height=400,
          stack=False,
          x_label="Cost Burden Category",
          y_label="Total Claims",
          color="#A7B8CF"
        )
      else:
        st.warning("No data available")
    except Exception as e:
      st.error(f"Error: {str(e)}")

def query_2_2() -> str:
  sql_query = r"""
SELECT MEMBER_AGE_SEGMENT, AVG_MEMBER_PAID
FROM AGG_AGE_GROUP_EXPERIENCE
ORDER BY AVG_MEMBER_PAID DESC;  """

  return sql_query

execute_query(query_2_2())

@st.fragment
def cell_2_2():
  with st.container():
    with st.container(horizontal=True, horizontal_alignment="distribute", vertical_alignment="center"):
      with st.container(height=80, border=False, vertical_alignment="center"):
        st.markdown("### Average Member Cost by Age Group")
      if st.button(
        ":material/refresh:", type="tertiary", key=f"refresh_button_cell_2_2", help="Refresh average_member_cost_by_age_group data"
      ):
        execute_query.clear(query_2_2())

    try:
      with st.spinner("Executing query", show_time=True):
        df = session.create_async_job(
          execute_query(query_2_2())
        ).result("pandas")

      if any(df.columns.duplicated()):
        new_names = []
        name_indexes = {}
        for name in df.columns:
          name_index = name_indexes.get(name, 0) + 1
          name_indexes[name] = name_index
          new_names.append(f"{name}_{name_index}" if name_index > 1 else name)
        df.columns = new_names

      # Prepare data for bar chart
      if len(df) > 0:
        df = df.groupby(
          by="MEMBER_AGE_SEGMENT",
          sort=False
        ).agg(
          col1=("AVG_MEMBER_PAID", "sum")
        ).rename(columns={
          "col1": "AVG_MEMBER_PAID (sum)"
        }).reset_index()

        df["/* Order Key (Generated by Snowflake) */"] = df.drop(columns="MEMBER_AGE_SEGMENT").sum(axis=1)

        datetime_primary_column = None
        if pd.api.types.is_datetime64_dtype(df["MEMBER_AGE_SEGMENT"]):
          datetime_primary_column = df["MEMBER_AGE_SEGMENT"]
        elif df["MEMBER_AGE_SEGMENT"].dtype == "object" and isinstance(df["MEMBER_AGE_SEGMENT"].get(df["MEMBER_AGE_SEGMENT"].first_valid_index()), dt.date):
          datetime_primary_column = pd.to_datetime(df["MEMBER_AGE_SEGMENT"], errors="coerce")
        if datetime_primary_column is not None and (datetime_primary_column.max() - datetime_primary_column.min()).days > len(df) * 2:
          # Use string type for sparse date range
          df["MEMBER_AGE_SEGMENT"] = df["MEMBER_AGE_SEGMENT"].astype("string")

        st.bar_chart(
          df,
          x="MEMBER_AGE_SEGMENT",
          y=[c for c in df.columns if c != "MEMBER_AGE_SEGMENT" and c != "/* Order Key (Generated by Snowflake) */"],
          sort="-/* Order Key (Generated by Snowflake) */",
          use_container_width=True,
          height=400,
          stack=False,
          x_label="Member Age Group",
          y_label="Average Cost for Member",
          color="#194A63"
        )
      else:
        st.warning("No data available")
    except Exception as e:
      st.error(f"Error: {str(e)}")

# Row 2: 2 Cells
col2_1, col2_2 = st.columns(2)
with col2_1:
  cell_2_1()
with col2_2:
  cell_2_2()

def query_3_1() -> str:
  sql_query = r"""
SELECT MEMBER_STATE, AVG_MEMBER_PAID
FROM AGG_STATE_PATIENT_EXPERIENCE
WHERE AVG_MEMBER_PAID >= 0
ORDER BY AVG_MEMBER_PAID DESC;  """

  return sql_query

execute_query(query_3_1())

@st.fragment
def cell_3_1():
  with st.container():
    with st.container(horizontal=True, horizontal_alignment="distribute", vertical_alignment="center"):
      with st.container(height=80, border=False, vertical_alignment="center"):
        st.markdown("### Average Member Cost by State")
      if st.button(
        ":material/refresh:", type="tertiary", key=f"refresh_button_cell_3_1", help="Refresh average_member_cost_by_state data"
      ):
        execute_query.clear(query_3_1())

    try:
      with st.spinner("Executing query", show_time=True):
        df = session.create_async_job(
          execute_query(query_3_1())
        ).result("pandas")

      if any(df.columns.duplicated()):
        new_names = []
        name_indexes = {}
        for name in df.columns:
          name_index = name_indexes.get(name, 0) + 1
          name_indexes[name] = name_index
          new_names.append(f"{name}_{name_index}" if name_index > 1 else name)
        df.columns = new_names

      # Prepare data for bar chart
      if len(df) > 0:
        df = df.groupby(
          by="MEMBER_STATE",
          sort=False
        ).agg(
          col1=("AVG_MEMBER_PAID", "sum")
        ).rename(columns={
          "col1": "AVG_MEMBER_PAID (sum)"
        }).reset_index()

        df["/* Order Key (Generated by Snowflake) */"] = df.drop(columns="MEMBER_STATE").sum(axis=1)

        datetime_primary_column = None
        if pd.api.types.is_datetime64_dtype(df["MEMBER_STATE"]):
          datetime_primary_column = df["MEMBER_STATE"]
        elif df["MEMBER_STATE"].dtype == "object" and isinstance(df["MEMBER_STATE"].get(df["MEMBER_STATE"].first_valid_index()), dt.date):
          datetime_primary_column = pd.to_datetime(df["MEMBER_STATE"], errors="coerce")
        if datetime_primary_column is not None and (datetime_primary_column.max() - datetime_primary_column.min()).days > len(df) * 2:
          # Use string type for sparse date range
          df["MEMBER_STATE"] = df["MEMBER_STATE"].astype("string")

        st.bar_chart(
          df,
          x="MEMBER_STATE",
          y=[c for c in df.columns if c != "MEMBER_STATE" and c != "/* Order Key (Generated by Snowflake) */"],
          sort="-/* Order Key (Generated by Snowflake) */",
          use_container_width=True,
          height=400,
          stack=False,
          x_label="Member State",
          y_label="Average Cost for Member",
          color="#8A5C3D"
        )
      else:
        st.warning("No data available")
    except Exception as e:
      st.error(f"Error: {str(e)}")

# Row 3: Single Cell
cell_3_1()

def query_4_1() -> str:
  sql_query = r"""
SELECT  
    DATE_SUBMITTED,
    COUNT(*) AS TOTAL_CLAIMS  
FROM CHIPMUNK_CURATION.CUR_RX_WEEKLY
WHERE IS_REVERSED_CLAIM = FALSE
GROUP BY DATE_SUBMITTED  
ORDER BY DATE_SUBMITTED;  """

  return sql_query

execute_query(query_4_1())

@st.fragment
def cell_4_1():
  with st.container():
    with st.container(horizontal=True, horizontal_alignment="distribute", vertical_alignment="center"):
      with st.container(height=80, border=False, vertical_alignment="center"):
        st.markdown("### Daily Prescription Claim Volume")
      if st.button(
        ":material/refresh:", type="tertiary", key=f"refresh_button_cell_4_1", help="Refresh daily_prescription_claim_volume data"
      ):
        execute_query.clear(query_4_1())

    try:
      with st.spinner("Executing query", show_time=True):
        df = session.create_async_job(
          execute_query(query_4_1())
        ).result("pandas")

      if any(df.columns.duplicated()):
        new_names = []
        name_indexes = {}
        for name in df.columns:
          name_index = name_indexes.get(name, 0) + 1
          name_indexes[name] = name_index
          new_names.append(f"{name}_{name_index}" if name_index > 1 else name)
        df.columns = new_names

      # Prepare data for line chart with aggregation
      if len(df) > 0:
        df = df.groupby(
          by="DATE_SUBMITTED",
          sort=False
        ).agg(
          col1=("TOTAL_CLAIMS", "sum")
        ).rename(columns={
          "col1": "TOTAL_CLAIMS (sum)"
        }).reset_index()

        st.area_chart(
          df.set_index("DATE_SUBMITTED"),
          use_container_width=True,
          height=400,
          x_label="Date Submitted",
          y_label="Total Claims",
          color = "#9D1F2D"
        )
      else:
        st.warning("No data available")
    except Exception as e:
      st.error(f"Error: {str(e)}")

def query_4_2() -> str:
  sql_query = r"""
SELECT FILL_AND_SUBMIT_SPEED_CATEGORY, TOTAL_CLAIMS
FROM AGG_FILL_SUBMIT_EXPERIENCE
WHERE FILL_AND_SUBMIT_SPEED_CATEGORY <> 'Unknown'
ORDER BY TOTAL_CLAIMS DESC;  """

  return sql_query

execute_query(query_4_2())

@st.fragment
def cell_4_2():
  with st.container():
    with st.container(horizontal=True, horizontal_alignment="distribute", vertical_alignment="center"):
      with st.container(height=80, border=False, vertical_alignment="center"):
        st.markdown("### Claim Submission Speed Distribution")
      if st.button(
        ":material/refresh:", type="tertiary", key=f"refresh_button_cell_4_2", help="Refresh claim_submission_speed_distribution data"
      ):
        execute_query.clear(query_4_2())

    try:
      with st.spinner("Executing query", show_time=True):
        df = session.create_async_job(
          execute_query(query_4_2())
        ).result("pandas")

      if any(df.columns.duplicated()):
        new_names = []
        name_indexes = {}
        for name in df.columns:
          name_index = name_indexes.get(name, 0) + 1
          name_indexes[name] = name_index
          new_names.append(f"{name}_{name_index}" if name_index > 1 else name)
        df.columns = new_names

      # Prepare data for bar chart
      if len(df) > 0:
        df = df.groupby(
          by="FILL_AND_SUBMIT_SPEED_CATEGORY",
          sort=False
        ).agg(
          col1=("TOTAL_CLAIMS", "sum")
        ).rename(columns={
          "col1": "TOTAL_CLAIMS (sum)"
        }).reset_index()

        df["/* Order Key (Generated by Snowflake) */"] = df.drop(columns="FILL_AND_SUBMIT_SPEED_CATEGORY").sum(axis=1)

        datetime_primary_column = None
        if pd.api.types.is_datetime64_dtype(df["FILL_AND_SUBMIT_SPEED_CATEGORY"]):
          datetime_primary_column = df["FILL_AND_SUBMIT_SPEED_CATEGORY"]
        elif df["FILL_AND_SUBMIT_SPEED_CATEGORY"].dtype == "object" and isinstance(df["FILL_AND_SUBMIT_SPEED_CATEGORY"].get(df["FILL_AND_SUBMIT_SPEED_CATEGORY"].first_valid_index()), dt.date):
          datetime_primary_column = pd.to_datetime(df["FILL_AND_SUBMIT_SPEED_CATEGORY"], errors="coerce")
        if datetime_primary_column is not None and (datetime_primary_column.max() - datetime_primary_column.min()).days > len(df) * 2:
          # Use string type for sparse date range
          df["FILL_AND_SUBMIT_SPEED_CATEGORY"] = df["FILL_AND_SUBMIT_SPEED_CATEGORY"].astype("string")

        st.bar_chart(
          df,
          x="FILL_AND_SUBMIT_SPEED_CATEGORY",
          y=[c for c in df.columns if c != "FILL_AND_SUBMIT_SPEED_CATEGORY" and c != "/* Order Key (Generated by Snowflake) */"],
          sort="-/* Order Key (Generated by Snowflake) */",
          use_container_width=True,
          height=400,
          horizontal=True,
          stack=False,
          y_label="Time to Fill",
          color = "#6E2C3A"
        )
      else:
        st.warning("No data available")
    except Exception as e:
      st.error(f"Error: {str(e)}")

# Row 4: 2 Cells
col4_1, col4_2 = st.columns(2)
with col4_1:
  cell_4_1()
with col4_2:
  cell_4_2()


# Footer
st.markdown("---")
st.markdown(
  "*Dashboard loaded: {}*".format(dt.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
)
