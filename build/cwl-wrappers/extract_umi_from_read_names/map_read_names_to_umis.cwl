cwlVersion: v1.0

class: Workflow

inputs:
  input_bam:
    type: File

  samtools_view_file:
    type: string
    default: samtools_view_bam.temp

  awk_pattern:
    type: string

  output_read_names_filename:
    type: string

outputs:
  read_names_file:
    type: File
    outputSource: awk/read_names_file

steps:
  samtools_view:
    run: samtools_view.cwl
    in:
      input_bam: input_bam
      samtools_view_file: samtools_view_file
    out: [samtools_view_file]

  awk:
    run: awk_extract_read_names_from_bam.cwl
    in:
      input_bam: samtools_view/samtools_view_file
      awk_pattern: awk_pattern
      output_read_names_filename: output_read_names_filename
    out: [read_names_file]

  map_read_names_to_umis:
    run: map_read_names_to_umis_python.cwl
    in:
      input_bed: awk/read_names_file
      output_file_name: duplex_umi_for_read_names.fastq # why fastq?
    out:
      [umi_to_read_name_mapping]