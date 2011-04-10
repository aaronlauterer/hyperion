module mpi_io

  use core_lib, only : mp_set_compression => hdf5_set_compression, &
       &               mp_open_new => hdf5_open_new, &
       &               mp_open_read => hdf5_open_read, &
       &               mp_open_write => hdf5_open_write, &
       &               mp_path_exists => hdf5_path_exists, &
       &               mp_open_group => hdf5_open_group, &
       &               mp_create_group => hdf5_create_group, &
       &               mp_close_group => hdf5_close_group, &
       &               mp_list_groups => hdf5_list_groups, &
       &               mp_table_write_header => hdf5_table_write_header, &
       &               mp_exists_keyword => hdf5_exists_keyword, &
       &               mp_read_keyword => hdf5_read_keyword, &
       &               mp_write_keyword => hdf5_write_keyword, &
       &               mp_table_read_column_auto => hdf5_table_read_column_auto, &
       &               mp_table_write_column => hdf5_table_write_column, &
       &               mp_read_array_auto => hdf5_read_array_auto, &
       &               mp_write_array => hdf5_write_array

  implicit none
  save

  private
  public :: mp_set_compression
  public :: mp_open_new
  public :: mp_open_read
  public :: mp_open_write
  public :: mp_path_exists
  public :: mp_open_group
  public :: mp_create_group
  public :: mp_close_group
  public :: mp_list_groups
  public :: mp_table_write_header
  public :: mp_exists_keyword
  public :: mp_read_keyword
  public :: mp_write_keyword
  public :: mp_table_read_column_auto
  public :: mp_table_write_column
  public :: mp_read_array_auto
  public :: mp_write_array

end module mpi_io
