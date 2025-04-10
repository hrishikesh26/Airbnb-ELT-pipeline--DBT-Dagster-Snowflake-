# import os

# from dagster import Definitions
# from dagster_dbt import DbtCliResource

# from .assets import dbtlearn_dbt_assets
# from .constants import dbt_project_dir
# from .schedules import schedules

# defs = Definitions(
#     assets=[dbtlearn_dbt_assets],
#     schedules=schedules,
#     resources={
#         "dbt": DbtCliResource(project_dir=os.fspath(dbt_project_dir)),
#     },
# )


# with the mentioning of assests for partioning - 

import os

from dagster import Definitions
from dagster_dbt import DbtCliResource

from .assets import dbtlearn_dbt_assets, dbtlearn_partitioned_dbt_assets
from .constants import dbt_project_dir
from .schedules import schedules

defs = Definitions(
    assets=[dbtlearn_dbt_assets, dbtlearn_partitioned_dbt_assets],
    schedules=schedules,
    resources={
        "dbt": DbtCliResource(project_dir=os.fspath(dbt_project_dir)),
    },
)
