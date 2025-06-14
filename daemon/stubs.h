/* libguestfs generated file
 * WARNING: THIS FILE IS GENERATED FROM THE FOLLOWING FILES:
 *          generator/daemon.ml
 *          and from the code in the generator/ subdirectory.
 * ANY CHANGES YOU MAKE TO THIS FILE WILL BE LOST.
 *
 * Copyright (C) 2009-2023 Red Hat Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef GUESTFSD_STUBS_H
#define GUESTFSD_STUBS_H

extern void acl_delete_def_file_stub (XDR *xdr_in);
extern void acl_get_file_stub (XDR *xdr_in);
extern void acl_set_file_stub (XDR *xdr_in);
extern void aug_clear_stub (XDR *xdr_in);
extern void aug_close_stub (XDR *xdr_in);
extern void aug_defnode_stub (XDR *xdr_in);
extern void aug_defvar_stub (XDR *xdr_in);
extern void aug_get_stub (XDR *xdr_in);
extern void aug_init_stub (XDR *xdr_in);
extern void aug_insert_stub (XDR *xdr_in);
extern void aug_label_stub (XDR *xdr_in);
extern void aug_load_stub (XDR *xdr_in);
extern void aug_ls_stub (XDR *xdr_in);
extern void aug_match_stub (XDR *xdr_in);
extern void aug_mv_stub (XDR *xdr_in);
extern void aug_rm_stub (XDR *xdr_in);
extern void aug_save_stub (XDR *xdr_in);
extern void aug_set_stub (XDR *xdr_in);
extern void aug_setm_stub (XDR *xdr_in);
extern void aug_transform_stub (XDR *xdr_in);
extern void available_all_groups_stub (XDR *xdr_in);
extern void base64_in_stub (XDR *xdr_in);
extern void base64_out_stub (XDR *xdr_in);
extern void blkdiscard_stub (XDR *xdr_in);
extern void blkdiscardzeroes_stub (XDR *xdr_in);
extern void blkid_stub (XDR *xdr_in);
extern void blockdev_flushbufs_stub (XDR *xdr_in);
extern void blockdev_getbsz_stub (XDR *xdr_in);
extern void blockdev_getro_stub (XDR *xdr_in);
extern void blockdev_getsize64_stub (XDR *xdr_in);
extern void blockdev_getss_stub (XDR *xdr_in);
extern void blockdev_getsz_stub (XDR *xdr_in);
extern void blockdev_rereadpt_stub (XDR *xdr_in);
extern void blockdev_setbsz_stub (XDR *xdr_in);
extern void blockdev_setra_stub (XDR *xdr_in);
extern void blockdev_setro_stub (XDR *xdr_in);
extern void blockdev_setrw_stub (XDR *xdr_in);
extern void btrfs_balance_cancel_stub (XDR *xdr_in);
extern void btrfs_balance_pause_stub (XDR *xdr_in);
extern void btrfs_balance_resume_stub (XDR *xdr_in);
extern void btrfs_balance_status_stub (XDR *xdr_in);
extern void btrfs_device_add_stub (XDR *xdr_in);
extern void btrfs_device_delete_stub (XDR *xdr_in);
extern void btrfs_filesystem_balance_stub (XDR *xdr_in);
extern void btrfs_filesystem_defragment_stub (XDR *xdr_in);
extern void btrfs_filesystem_resize_stub (XDR *xdr_in);
extern void btrfs_filesystem_show_stub (XDR *xdr_in);
extern void btrfs_filesystem_sync_stub (XDR *xdr_in);
extern void btrfs_fsck_stub (XDR *xdr_in);
extern void btrfs_image_stub (XDR *xdr_in);
extern void btrfs_qgroup_assign_stub (XDR *xdr_in);
extern void btrfs_qgroup_create_stub (XDR *xdr_in);
extern void btrfs_qgroup_destroy_stub (XDR *xdr_in);
extern void btrfs_qgroup_limit_stub (XDR *xdr_in);
extern void btrfs_qgroup_remove_stub (XDR *xdr_in);
extern void btrfs_qgroup_show_stub (XDR *xdr_in);
extern void btrfs_quota_enable_stub (XDR *xdr_in);
extern void btrfs_quota_rescan_stub (XDR *xdr_in);
extern void btrfs_replace_stub (XDR *xdr_in);
extern void btrfs_rescue_chunk_recover_stub (XDR *xdr_in);
extern void btrfs_rescue_super_recover_stub (XDR *xdr_in);
extern void btrfs_scrub_cancel_stub (XDR *xdr_in);
extern void btrfs_scrub_resume_stub (XDR *xdr_in);
extern void btrfs_scrub_start_stub (XDR *xdr_in);
extern void btrfs_scrub_status_stub (XDR *xdr_in);
extern void btrfs_set_seeding_stub (XDR *xdr_in);
extern void btrfs_subvolume_create_stub (XDR *xdr_in);
extern void btrfs_subvolume_delete_stub (XDR *xdr_in);
extern void btrfs_subvolume_get_default_stub (XDR *xdr_in);
extern void btrfs_subvolume_list_stub (XDR *xdr_in);
extern void btrfs_subvolume_set_default_stub (XDR *xdr_in);
extern void btrfs_subvolume_show_stub (XDR *xdr_in);
extern void btrfs_subvolume_snapshot_stub (XDR *xdr_in);
extern void btrfstune_enable_extended_inode_refs_stub (XDR *xdr_in);
extern void btrfstune_enable_skinny_metadata_extent_refs_stub (XDR *xdr_in);
extern void btrfstune_seeding_stub (XDR *xdr_in);
extern void cap_get_file_stub (XDR *xdr_in);
extern void cap_set_file_stub (XDR *xdr_in);
extern void case_sensitive_path_stub (XDR *xdr_in);
extern void checksum_stub (XDR *xdr_in);
extern void checksum_device_stub (XDR *xdr_in);
extern void checksums_out_stub (XDR *xdr_in);
extern void chmod_stub (XDR *xdr_in);
extern void chown_stub (XDR *xdr_in);
extern void clevis_luks_unlock_stub (XDR *xdr_in);
extern void command_stub (XDR *xdr_in);
extern void command_lines_stub (XDR *xdr_in);
extern void compress_device_out_stub (XDR *xdr_in);
extern void compress_out_stub (XDR *xdr_in);
extern void copy_attributes_stub (XDR *xdr_in);
extern void copy_device_to_device_stub (XDR *xdr_in);
extern void copy_device_to_file_stub (XDR *xdr_in);
extern void copy_file_to_device_stub (XDR *xdr_in);
extern void copy_file_to_file_stub (XDR *xdr_in);
extern void copy_size_stub (XDR *xdr_in);
extern void cp_stub (XDR *xdr_in);
extern void cp_a_stub (XDR *xdr_in);
extern void cp_r_stub (XDR *xdr_in);
extern void cpio_out_stub (XDR *xdr_in);
extern void cryptsetup_close_stub (XDR *xdr_in);
extern void cryptsetup_open_stub (XDR *xdr_in);
extern void dd_stub (XDR *xdr_in);
extern void debug_stub (XDR *xdr_in);
extern void debug_upload_stub (XDR *xdr_in);
extern void df_stub (XDR *xdr_in);
extern void df_h_stub (XDR *xdr_in);
extern void dmesg_stub (XDR *xdr_in);
extern void download_stub (XDR *xdr_in);
extern void download_blocks_stub (XDR *xdr_in);
extern void download_inode_stub (XDR *xdr_in);
extern void download_offset_stub (XDR *xdr_in);
extern void drop_caches_stub (XDR *xdr_in);
extern void du_stub (XDR *xdr_in);
extern void e2fsck_stub (XDR *xdr_in);
extern void e2fsck_f_stub (XDR *xdr_in);
extern void echo_daemon_stub (XDR *xdr_in);
extern void egrep_stub (XDR *xdr_in);
extern void egrepi_stub (XDR *xdr_in);
extern void equal_stub (XDR *xdr_in);
extern void exists_stub (XDR *xdr_in);
extern void extlinux_stub (XDR *xdr_in);
extern void f2fs_expand_stub (XDR *xdr_in);
extern void fallocate_stub (XDR *xdr_in);
extern void fallocate64_stub (XDR *xdr_in);
extern void fgrep_stub (XDR *xdr_in);
extern void fgrepi_stub (XDR *xdr_in);
extern void file_stub (XDR *xdr_in);
extern void file_architecture_stub (XDR *xdr_in);
extern void filesize_stub (XDR *xdr_in);
extern void filesystem_available_stub (XDR *xdr_in);
extern void fill_stub (XDR *xdr_in);
extern void fill_dir_stub (XDR *xdr_in);
extern void fill_pattern_stub (XDR *xdr_in);
extern void find0_stub (XDR *xdr_in);
extern void findfs_label_stub (XDR *xdr_in);
extern void findfs_partlabel_stub (XDR *xdr_in);
extern void findfs_partuuid_stub (XDR *xdr_in);
extern void findfs_uuid_stub (XDR *xdr_in);
extern void fsck_stub (XDR *xdr_in);
extern void fstrim_stub (XDR *xdr_in);
extern void get_e2attrs_stub (XDR *xdr_in);
extern void get_e2generation_stub (XDR *xdr_in);
extern void get_e2label_stub (XDR *xdr_in);
extern void get_e2uuid_stub (XDR *xdr_in);
extern void get_umask_stub (XDR *xdr_in);
extern void getcon_stub (XDR *xdr_in);
extern void getxattr_stub (XDR *xdr_in);
extern void getxattrs_stub (XDR *xdr_in);
extern void glob_expand_stub (XDR *xdr_in);
extern void grep_stub (XDR *xdr_in);
extern void grepi_stub (XDR *xdr_in);
extern void grub_install_stub (XDR *xdr_in);
extern void head_stub (XDR *xdr_in);
extern void head_n_stub (XDR *xdr_in);
extern void hexdump_stub (XDR *xdr_in);
extern void hivex_close_stub (XDR *xdr_in);
extern void hivex_commit_stub (XDR *xdr_in);
extern void hivex_node_add_child_stub (XDR *xdr_in);
extern void hivex_node_children_stub (XDR *xdr_in);
extern void hivex_node_delete_child_stub (XDR *xdr_in);
extern void hivex_node_get_child_stub (XDR *xdr_in);
extern void hivex_node_get_value_stub (XDR *xdr_in);
extern void hivex_node_name_stub (XDR *xdr_in);
extern void hivex_node_parent_stub (XDR *xdr_in);
extern void hivex_node_set_value_stub (XDR *xdr_in);
extern void hivex_node_values_stub (XDR *xdr_in);
extern void hivex_open_stub (XDR *xdr_in);
extern void hivex_root_stub (XDR *xdr_in);
extern void hivex_value_key_stub (XDR *xdr_in);
extern void hivex_value_string_stub (XDR *xdr_in);
extern void hivex_value_type_stub (XDR *xdr_in);
extern void hivex_value_utf8_stub (XDR *xdr_in);
extern void hivex_value_value_stub (XDR *xdr_in);
extern void initrd_cat_stub (XDR *xdr_in);
extern void initrd_list_stub (XDR *xdr_in);
extern void inotify_add_watch_stub (XDR *xdr_in);
extern void inotify_close_stub (XDR *xdr_in);
extern void inotify_files_stub (XDR *xdr_in);
extern void inotify_init_stub (XDR *xdr_in);
extern void inotify_read_stub (XDR *xdr_in);
extern void inotify_rm_watch_stub (XDR *xdr_in);
extern void inspect_get_arch_stub (XDR *xdr_in);
extern void inspect_get_build_id_stub (XDR *xdr_in);
extern void inspect_get_distro_stub (XDR *xdr_in);
extern void inspect_get_drive_mappings_stub (XDR *xdr_in);
extern void inspect_get_filesystems_stub (XDR *xdr_in);
extern void inspect_get_format_stub (XDR *xdr_in);
extern void inspect_get_hostname_stub (XDR *xdr_in);
extern void inspect_get_major_version_stub (XDR *xdr_in);
extern void inspect_get_minor_version_stub (XDR *xdr_in);
extern void inspect_get_mountpoints_stub (XDR *xdr_in);
extern void inspect_get_package_format_stub (XDR *xdr_in);
extern void inspect_get_package_management_stub (XDR *xdr_in);
extern void inspect_get_product_name_stub (XDR *xdr_in);
extern void inspect_get_product_variant_stub (XDR *xdr_in);
extern void inspect_get_roots_stub (XDR *xdr_in);
extern void inspect_get_type_stub (XDR *xdr_in);
extern void inspect_get_windows_current_control_set_stub (XDR *xdr_in);
extern void inspect_get_windows_software_hive_stub (XDR *xdr_in);
extern void inspect_get_windows_system_hive_stub (XDR *xdr_in);
extern void inspect_get_windows_systemroot_stub (XDR *xdr_in);
extern void inspect_is_live_stub (XDR *xdr_in);
extern void inspect_is_multipart_stub (XDR *xdr_in);
extern void inspect_is_netinst_stub (XDR *xdr_in);
extern void inspect_os_stub (XDR *xdr_in);
extern void internal_autosync_stub (XDR *xdr_in);
extern void internal_exit_stub (XDR *xdr_in);
extern void internal_feature_available_stub (XDR *xdr_in);
extern void internal_filesystem_walk_stub (XDR *xdr_in);
extern void internal_find_inode_stub (XDR *xdr_in);
extern void internal_journal_get_stub (XDR *xdr_in);
extern void internal_list_rpm_applications_stub (XDR *xdr_in);
extern void internal_lstatnslist_stub (XDR *xdr_in);
extern void internal_lxattrlist_stub (XDR *xdr_in);
extern void internal_parse_mountable_stub (XDR *xdr_in);
extern void internal_readdir_stub (XDR *xdr_in);
extern void internal_readlinklist_stub (XDR *xdr_in);
extern void internal_rhbz914931_stub (XDR *xdr_in);
extern void internal_upload_stub (XDR *xdr_in);
extern void internal_write_stub (XDR *xdr_in);
extern void internal_write_append_stub (XDR *xdr_in);
extern void internal_yara_scan_stub (XDR *xdr_in);
extern void is_blockdev_stub (XDR *xdr_in);
extern void is_chardev_stub (XDR *xdr_in);
extern void is_dir_stub (XDR *xdr_in);
extern void is_fifo_stub (XDR *xdr_in);
extern void is_file_stub (XDR *xdr_in);
extern void is_lv_stub (XDR *xdr_in);
extern void is_socket_stub (XDR *xdr_in);
extern void is_symlink_stub (XDR *xdr_in);
extern void is_whole_device_stub (XDR *xdr_in);
extern void is_zero_stub (XDR *xdr_in);
extern void is_zero_device_stub (XDR *xdr_in);
extern void isoinfo_stub (XDR *xdr_in);
extern void isoinfo_device_stub (XDR *xdr_in);
extern void journal_close_stub (XDR *xdr_in);
extern void journal_get_data_threshold_stub (XDR *xdr_in);
extern void journal_get_realtime_usec_stub (XDR *xdr_in);
extern void journal_next_stub (XDR *xdr_in);
extern void journal_open_stub (XDR *xdr_in);
extern void journal_set_data_threshold_stub (XDR *xdr_in);
extern void journal_skip_stub (XDR *xdr_in);
extern void lchown_stub (XDR *xdr_in);
extern void ldmtool_create_all_stub (XDR *xdr_in);
extern void ldmtool_diskgroup_disks_stub (XDR *xdr_in);
extern void ldmtool_diskgroup_name_stub (XDR *xdr_in);
extern void ldmtool_diskgroup_volumes_stub (XDR *xdr_in);
extern void ldmtool_remove_all_stub (XDR *xdr_in);
extern void ldmtool_scan_stub (XDR *xdr_in);
extern void ldmtool_scan_devices_stub (XDR *xdr_in);
extern void ldmtool_volume_hint_stub (XDR *xdr_in);
extern void ldmtool_volume_partitions_stub (XDR *xdr_in);
extern void ldmtool_volume_type_stub (XDR *xdr_in);
extern void lgetxattr_stub (XDR *xdr_in);
extern void lgetxattrs_stub (XDR *xdr_in);
extern void list_9p_stub (XDR *xdr_in);
extern void list_devices_stub (XDR *xdr_in);
extern void list_disk_labels_stub (XDR *xdr_in);
extern void list_dm_devices_stub (XDR *xdr_in);
extern void list_filesystems_stub (XDR *xdr_in);
extern void list_ldm_partitions_stub (XDR *xdr_in);
extern void list_ldm_volumes_stub (XDR *xdr_in);
extern void list_md_devices_stub (XDR *xdr_in);
extern void list_partitions_stub (XDR *xdr_in);
extern void ll_stub (XDR *xdr_in);
extern void llz_stub (XDR *xdr_in);
extern void ln_stub (XDR *xdr_in);
extern void ln_f_stub (XDR *xdr_in);
extern void ln_s_stub (XDR *xdr_in);
extern void ln_sf_stub (XDR *xdr_in);
extern void lremovexattr_stub (XDR *xdr_in);
extern void ls0_stub (XDR *xdr_in);
extern void lsetxattr_stub (XDR *xdr_in);
extern void lstatns_stub (XDR *xdr_in);
extern void luks_add_key_stub (XDR *xdr_in);
extern void luks_close_stub (XDR *xdr_in);
extern void luks_format_stub (XDR *xdr_in);
extern void luks_format_cipher_stub (XDR *xdr_in);
extern void luks_kill_slot_stub (XDR *xdr_in);
extern void luks_open_stub (XDR *xdr_in);
extern void luks_open_ro_stub (XDR *xdr_in);
extern void luks_uuid_stub (XDR *xdr_in);
extern void lvcreate_stub (XDR *xdr_in);
extern void lvcreate_free_stub (XDR *xdr_in);
extern void lvm_canonical_lv_name_stub (XDR *xdr_in);
extern void lvm_clear_filter_stub (XDR *xdr_in);
extern void lvm_remove_all_stub (XDR *xdr_in);
extern void lvm_scan_stub (XDR *xdr_in);
extern void lvm_set_filter_stub (XDR *xdr_in);
extern void lvremove_stub (XDR *xdr_in);
extern void lvrename_stub (XDR *xdr_in);
extern void lvresize_stub (XDR *xdr_in);
extern void lvresize_free_stub (XDR *xdr_in);
extern void lvs_stub (XDR *xdr_in);
extern void lvs_full_stub (XDR *xdr_in);
extern void lvuuid_stub (XDR *xdr_in);
extern void md_create_stub (XDR *xdr_in);
extern void md_detail_stub (XDR *xdr_in);
extern void md_stat_stub (XDR *xdr_in);
extern void md_stop_stub (XDR *xdr_in);
extern void mkdir_stub (XDR *xdr_in);
extern void mkdir_mode_stub (XDR *xdr_in);
extern void mkdir_p_stub (XDR *xdr_in);
extern void mkdtemp_stub (XDR *xdr_in);
extern void mke2fs_stub (XDR *xdr_in);
extern void mke2fs_J_stub (XDR *xdr_in);
extern void mke2fs_JL_stub (XDR *xdr_in);
extern void mke2fs_JU_stub (XDR *xdr_in);
extern void mke2journal_stub (XDR *xdr_in);
extern void mke2journal_L_stub (XDR *xdr_in);
extern void mke2journal_U_stub (XDR *xdr_in);
extern void mkfifo_stub (XDR *xdr_in);
extern void mkfs_stub (XDR *xdr_in);
extern void mkfs_b_stub (XDR *xdr_in);
extern void mkfs_btrfs_stub (XDR *xdr_in);
extern void mklost_and_found_stub (XDR *xdr_in);
extern void mkmountpoint_stub (XDR *xdr_in);
extern void mknod_stub (XDR *xdr_in);
extern void mknod_b_stub (XDR *xdr_in);
extern void mknod_c_stub (XDR *xdr_in);
extern void mksquashfs_stub (XDR *xdr_in);
extern void mkswap_stub (XDR *xdr_in);
extern void mkswap_L_stub (XDR *xdr_in);
extern void mkswap_U_stub (XDR *xdr_in);
extern void mkswap_file_stub (XDR *xdr_in);
extern void mktemp_stub (XDR *xdr_in);
extern void modprobe_stub (XDR *xdr_in);
extern void mount_stub (XDR *xdr_in);
extern void mount_9p_stub (XDR *xdr_in);
extern void mount_loop_stub (XDR *xdr_in);
extern void mount_options_stub (XDR *xdr_in);
extern void mount_ro_stub (XDR *xdr_in);
extern void mount_vfs_stub (XDR *xdr_in);
extern void mountpoints_stub (XDR *xdr_in);
extern void mounts_stub (XDR *xdr_in);
extern void mv_stub (XDR *xdr_in);
extern void nr_devices_stub (XDR *xdr_in);
extern void ntfs_3g_probe_stub (XDR *xdr_in);
extern void ntfscat_i_stub (XDR *xdr_in);
extern void ntfsclone_in_stub (XDR *xdr_in);
extern void ntfsclone_out_stub (XDR *xdr_in);
extern void ntfsfix_stub (XDR *xdr_in);
extern void ntfsresize_stub (XDR *xdr_in);
extern void ntfsresize_size_stub (XDR *xdr_in);
extern void part_add_stub (XDR *xdr_in);
extern void part_del_stub (XDR *xdr_in);
extern void part_disk_stub (XDR *xdr_in);
extern void part_expand_gpt_stub (XDR *xdr_in);
extern void part_get_bootable_stub (XDR *xdr_in);
extern void part_get_disk_guid_stub (XDR *xdr_in);
extern void part_get_gpt_attributes_stub (XDR *xdr_in);
extern void part_get_gpt_guid_stub (XDR *xdr_in);
extern void part_get_gpt_type_stub (XDR *xdr_in);
extern void part_get_mbr_id_stub (XDR *xdr_in);
extern void part_get_mbr_part_type_stub (XDR *xdr_in);
extern void part_get_name_stub (XDR *xdr_in);
extern void part_get_parttype_stub (XDR *xdr_in);
extern void part_init_stub (XDR *xdr_in);
extern void part_list_stub (XDR *xdr_in);
extern void part_resize_stub (XDR *xdr_in);
extern void part_set_bootable_stub (XDR *xdr_in);
extern void part_set_disk_guid_stub (XDR *xdr_in);
extern void part_set_disk_guid_random_stub (XDR *xdr_in);
extern void part_set_gpt_attributes_stub (XDR *xdr_in);
extern void part_set_gpt_guid_stub (XDR *xdr_in);
extern void part_set_gpt_type_stub (XDR *xdr_in);
extern void part_set_mbr_id_stub (XDR *xdr_in);
extern void part_set_name_stub (XDR *xdr_in);
extern void part_to_dev_stub (XDR *xdr_in);
extern void part_to_partnum_stub (XDR *xdr_in);
extern void ping_daemon_stub (XDR *xdr_in);
extern void pread_stub (XDR *xdr_in);
extern void pread_device_stub (XDR *xdr_in);
extern void pvchange_uuid_stub (XDR *xdr_in);
extern void pvchange_uuid_all_stub (XDR *xdr_in);
extern void pvcreate_stub (XDR *xdr_in);
extern void pvremove_stub (XDR *xdr_in);
extern void pvresize_stub (XDR *xdr_in);
extern void pvresize_size_stub (XDR *xdr_in);
extern void pvs_stub (XDR *xdr_in);
extern void pvs_full_stub (XDR *xdr_in);
extern void pvuuid_stub (XDR *xdr_in);
extern void pwrite_stub (XDR *xdr_in);
extern void pwrite_device_stub (XDR *xdr_in);
extern void readlink_stub (XDR *xdr_in);
extern void realpath_stub (XDR *xdr_in);
extern void remount_stub (XDR *xdr_in);
extern void removexattr_stub (XDR *xdr_in);
extern void rename_stub (XDR *xdr_in);
extern void resize2fs_stub (XDR *xdr_in);
extern void resize2fs_M_stub (XDR *xdr_in);
extern void resize2fs_size_stub (XDR *xdr_in);
extern void rm_stub (XDR *xdr_in);
extern void rm_f_stub (XDR *xdr_in);
extern void rm_rf_stub (XDR *xdr_in);
extern void rmdir_stub (XDR *xdr_in);
extern void rmmountpoint_stub (XDR *xdr_in);
extern void rsync_stub (XDR *xdr_in);
extern void rsync_in_stub (XDR *xdr_in);
extern void rsync_out_stub (XDR *xdr_in);
extern void scrub_device_stub (XDR *xdr_in);
extern void scrub_file_stub (XDR *xdr_in);
extern void scrub_freespace_stub (XDR *xdr_in);
extern void selinux_relabel_stub (XDR *xdr_in);
extern void set_e2attrs_stub (XDR *xdr_in);
extern void set_e2generation_stub (XDR *xdr_in);
extern void set_e2label_stub (XDR *xdr_in);
extern void set_e2uuid_stub (XDR *xdr_in);
extern void set_label_stub (XDR *xdr_in);
extern void set_uuid_stub (XDR *xdr_in);
extern void set_uuid_random_stub (XDR *xdr_in);
extern void setcon_stub (XDR *xdr_in);
extern void setxattr_stub (XDR *xdr_in);
extern void sfdisk_stub (XDR *xdr_in);
extern void sfdiskM_stub (XDR *xdr_in);
extern void sfdisk_N_stub (XDR *xdr_in);
extern void sfdisk_disk_geometry_stub (XDR *xdr_in);
extern void sfdisk_kernel_geometry_stub (XDR *xdr_in);
extern void sfdisk_l_stub (XDR *xdr_in);
extern void sh_stub (XDR *xdr_in);
extern void sh_lines_stub (XDR *xdr_in);
extern void sleep_stub (XDR *xdr_in);
extern void statns_stub (XDR *xdr_in);
extern void statvfs_stub (XDR *xdr_in);
extern void strings_stub (XDR *xdr_in);
extern void strings_e_stub (XDR *xdr_in);
extern void swapoff_device_stub (XDR *xdr_in);
extern void swapoff_file_stub (XDR *xdr_in);
extern void swapoff_label_stub (XDR *xdr_in);
extern void swapoff_uuid_stub (XDR *xdr_in);
extern void swapon_device_stub (XDR *xdr_in);
extern void swapon_file_stub (XDR *xdr_in);
extern void swapon_label_stub (XDR *xdr_in);
extern void swapon_uuid_stub (XDR *xdr_in);
extern void sync_stub (XDR *xdr_in);
extern void syslinux_stub (XDR *xdr_in);
extern void tail_stub (XDR *xdr_in);
extern void tail_n_stub (XDR *xdr_in);
extern void tar_in_stub (XDR *xdr_in);
extern void tar_out_stub (XDR *xdr_in);
extern void tgz_in_stub (XDR *xdr_in);
extern void tgz_out_stub (XDR *xdr_in);
extern void touch_stub (XDR *xdr_in);
extern void truncate_stub (XDR *xdr_in);
extern void truncate_size_stub (XDR *xdr_in);
extern void tune2fs_stub (XDR *xdr_in);
extern void tune2fs_l_stub (XDR *xdr_in);
extern void txz_in_stub (XDR *xdr_in);
extern void txz_out_stub (XDR *xdr_in);
extern void umask_stub (XDR *xdr_in);
extern void umount_stub (XDR *xdr_in);
extern void umount_all_stub (XDR *xdr_in);
extern void upload_stub (XDR *xdr_in);
extern void upload_offset_stub (XDR *xdr_in);
extern void utimens_stub (XDR *xdr_in);
extern void utsname_stub (XDR *xdr_in);
extern void vfs_label_stub (XDR *xdr_in);
extern void vfs_minimum_size_stub (XDR *xdr_in);
extern void vfs_type_stub (XDR *xdr_in);
extern void vfs_uuid_stub (XDR *xdr_in);
extern void vg_activate_stub (XDR *xdr_in);
extern void vg_activate_all_stub (XDR *xdr_in);
extern void vgchange_uuid_stub (XDR *xdr_in);
extern void vgchange_uuid_all_stub (XDR *xdr_in);
extern void vgcreate_stub (XDR *xdr_in);
extern void vglvuuids_stub (XDR *xdr_in);
extern void vgmeta_stub (XDR *xdr_in);
extern void vgpvuuids_stub (XDR *xdr_in);
extern void vgremove_stub (XDR *xdr_in);
extern void vgrename_stub (XDR *xdr_in);
extern void vgs_stub (XDR *xdr_in);
extern void vgs_full_stub (XDR *xdr_in);
extern void vgscan_stub (XDR *xdr_in);
extern void vguuid_stub (XDR *xdr_in);
extern void wc_c_stub (XDR *xdr_in);
extern void wc_l_stub (XDR *xdr_in);
extern void wc_w_stub (XDR *xdr_in);
extern void wipefs_stub (XDR *xdr_in);
extern void write_file_stub (XDR *xdr_in);
extern void xfs_admin_stub (XDR *xdr_in);
extern void xfs_growfs_stub (XDR *xdr_in);
extern void xfs_info_stub (XDR *xdr_in);
extern void xfs_repair_stub (XDR *xdr_in);
extern void yara_destroy_stub (XDR *xdr_in);
extern void yara_load_stub (XDR *xdr_in);
extern void zegrep_stub (XDR *xdr_in);
extern void zegrepi_stub (XDR *xdr_in);
extern void zero_stub (XDR *xdr_in);
extern void zero_device_stub (XDR *xdr_in);
extern void zero_free_space_stub (XDR *xdr_in);
extern void zerofree_stub (XDR *xdr_in);
extern void zfgrep_stub (XDR *xdr_in);
extern void zfgrepi_stub (XDR *xdr_in);
extern void zfile_stub (XDR *xdr_in);
extern void zgrep_stub (XDR *xdr_in);
extern void zgrepi_stub (XDR *xdr_in);

#endif /* GUESTFSD_STUBS_H */
