class: Workflow

inputs:
  fastq1:
    type:
      type: array
      items:
        type: array
        items: File
  fastq2:
    type:
      type: array
      items:
        type: array
        items: File
  umi_length:
    type:
      type: array
      items: string
  output_project_folder:
    type:
      type: array
      items: string
  outdir:
    type:
      type: array
      items: string

outputs:
  processed_fastq_1:
    type:
      type: array
      items: File
    outputSource: clipping/processed_fastq_1

  processed_fastq_2:
    type:
      type: array
      items: File
    outputSource: clipping/processed_fastq_2

  composite_umi_frequencies:
    type:
      type: array
      items: File
    outputSource: clipping/composite_umi_frequencies

  info:
    type:
      type: array
      items: File
    outputSource: clipping/info

  sample_sheet:
    type:
      type: array
      items: File
    outputSource: clipping/sample_sheet

  umi_frequencies:
    type:
      type: array
      items: File
    outputSource: clipping/umi_frequencies

steps:
  clipping:
    run: cmo-marianas.ProcessLoopUMIFastq.cwl
    in:
      fastq1: fastq1
      fastq2: fastq2
      umi_length: umi_length
      output_project_folder: output_project_folder
      outdir: outdir

    scatter: [fastq1, fastq2, umi_length, output_project_folder, outdir]
    scatterMethod: dotproduct
    out: [processed_fastq_1, processed_fastq_2, composite_umi_frequencies, info, sample_sheet, umi_frequencies]
