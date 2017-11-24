cwlVersion: cwl:v1.0

class: CommandLineTool

baseCommand: [cmo_plotting_module]

arguments: [""]

doc: |
  None

# /opt/common/CentOS_6/R/R-3.1.2/bin/Rscript
# --vanilla /ifs/work/bergerm1/Innovation/sandbox/ian/QC-module/plot-modules/plotting-collapsed-bams.r
# -i ${TABLES_OUTPUT_DIR}
# -iw ${WALTZ_OUTPUT_DIR}
# -o ${PLOTS_OUTPUT_DIR}

inputs:
  input_tables:
    type: Directory
    inputBinding:
      prefix: -i

  input_waltz:
    type: Directory
    inputBinding:
      prefix: -iw

  output_folder:
    type: String
    inputBinding:
      prefix: -o
