# libguestfs generated file
# WARNING: THIS FILE IS GENERATED FROM THE FOLLOWING FILES:
#          generator/perl.ml
#          and from the code in the generator/ subdirectory.
# ANY CHANGES YOU MAKE TO THIS FILE WILL BE LOST.
#
# Copyright (C) 2009-2023 Red Hat Inc.
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

=encoding utf8

=pod

=head1 NAME

Sys::Guestfs - Perl bindings for libguestfs

=head1 SYNOPSIS

 use Sys::Guestfs;

 my $g = Sys::Guestfs->new ();
 $g->add_drive_opts ('guest.img', format => 'raw');
 $g->launch ();
 $g->mount ('/dev/sda1', '/');
 $g->touch ('/hello');
 $g->shutdown ();
 $g->close ();

=head1 DESCRIPTION

The C<Sys::Guestfs> module provides a Perl XS binding to the
libguestfs API for examining and modifying virtual machine
disk images.

Amongst the things this is good for: making batch configuration
changes to guests, getting disk used/free statistics (see also:
virt-df), migrating between virtualization systems (see also:
virt-p2v), performing partial backups, performing partial guest
clones, cloning guests and changing registry/UUID/hostname info, and
much else besides.

Libguestfs uses Linux kernel and qemu code, and can access any type of
guest filesystem that Linux and qemu can, including but not limited
to: ext2/3/4, btrfs, FAT and NTFS, LVM, many different disk partition
schemes, qcow, qcow2, vmdk.

Libguestfs provides ways to enumerate guest storage (eg. partitions,
LVs, what filesystem is in each LV, etc.).  It can also run commands
in the context of the guest.  Also you can access filesystems over
FUSE.

=head1 ERRORS

All errors turn into calls to C<croak> (see L<Carp(3)>).

The error string from libguestfs is directly available from
C<$@>.  Use the C<last_errno> method if you want to get the errno.

=head1 METHODS

=over 4

=cut

package Sys::Guestfs;

use strict;
use warnings;

# This is always 1.0, never changes, and is unrelated to the
# real libguestfs version.  If you want to find the libguestfs
# library version, use $g->version.
use vars qw($VERSION);
$VERSION = '1.0';

require XSLoader;
XSLoader::load ('Sys::Guestfs');

=item $g = Sys::Guestfs->new ([environment => 0,] [close_on_exit => 0]);

Create a new guestfs handle.

If the optional argument C<environment> is false, then
the C<GUESTFS_CREATE_NO_ENVIRONMENT> flag is set.

If the optional argument C<close_on_exit> is false, then
the C<GUESTFS_CREATE_NO_CLOSE_ON_EXIT> flag is set.

=cut

sub new {
  my $proto = shift;
  my $class = ref ($proto) || $proto;
  my %flags = @_;

  my $flags = 0;
  $flags |= 1 if exists $flags{environment} && !$flags{environment};
  $flags |= 2 if exists $flags{close_on_exit} && !$flags{close_on_exit};

  my $g = Sys::Guestfs::_create ($flags);
  my $self = { _g => $g, _flags => $flags };
  bless $self, $class;

  # If we don't do this, the program name is always set to 'perl'.
  my $program = $0;
  $program =~ s{.*/}{};
  $self->set_program ($program);

  return $self;
}

=item $g->close ();

Explicitly close the guestfs handle.

B<Note:> You should not usually call this function.  The handle will
be closed implicitly when its reference count goes to zero (eg.
when it goes out of scope or the program ends).  This call is
only required in some exceptional cases, such as where the program
may contain cached references to the handle 'somewhere' and you
really have to have the close happen right away.  After calling
C<close> the program must not call any method (including C<close>)
on the handle (but the implicit call to C<DESTROY> that happens
when the final reference is cleaned up is OK).

=item $Sys::Guestfs::EVENT_CLOSE

See L<guestfs(3)/GUESTFS_EVENT_CLOSE>.

=cut

our $EVENT_CLOSE = 0x1;

=item $Sys::Guestfs::EVENT_SUBPROCESS_QUIT

See L<guestfs(3)/GUESTFS_EVENT_SUBPROCESS_QUIT>.

=cut

our $EVENT_SUBPROCESS_QUIT = 0x2;

=item $Sys::Guestfs::EVENT_LAUNCH_DONE

See L<guestfs(3)/GUESTFS_EVENT_LAUNCH_DONE>.

=cut

our $EVENT_LAUNCH_DONE = 0x4;

=item $Sys::Guestfs::EVENT_PROGRESS

See L<guestfs(3)/GUESTFS_EVENT_PROGRESS>.

=cut

our $EVENT_PROGRESS = 0x8;

=item $Sys::Guestfs::EVENT_APPLIANCE

See L<guestfs(3)/GUESTFS_EVENT_APPLIANCE>.

=cut

our $EVENT_APPLIANCE = 0x10;

=item $Sys::Guestfs::EVENT_LIBRARY

See L<guestfs(3)/GUESTFS_EVENT_LIBRARY>.

=cut

our $EVENT_LIBRARY = 0x20;

=item $Sys::Guestfs::EVENT_TRACE

See L<guestfs(3)/GUESTFS_EVENT_TRACE>.

=cut

our $EVENT_TRACE = 0x40;

=item $Sys::Guestfs::EVENT_ENTER

See L<guestfs(3)/GUESTFS_EVENT_ENTER>.

=cut

our $EVENT_ENTER = 0x80;

=item $Sys::Guestfs::EVENT_LIBVIRT_AUTH

See L<guestfs(3)/GUESTFS_EVENT_LIBVIRT_AUTH>.

=cut

our $EVENT_LIBVIRT_AUTH = 0x100;

=item $Sys::Guestfs::EVENT_WARNING

See L<guestfs(3)/GUESTFS_EVENT_WARNING>.

=cut

our $EVENT_WARNING = 0x200;

=item $Sys::Guestfs::EVENT_ALL

See L<guestfs(3)/GUESTFS_EVENT_ALL>.

=cut

our $EVENT_ALL = 0x3ff;

=item $event_handle = $g->set_event_callback (\&cb, $event_bitmask);

Register C<cb> as a callback function for all of the events
in C<$event_bitmask> (one or more C<$Sys::Guestfs::EVENT_*> flags
logically or'd together).

This function returns an event handle which
can be used to delete the callback using C<delete_event_callback>.

The callback function receives 4 parameters:

 &cb ($event, $event_handle, $buf, $array)

=over 4

=item $event

The event which happened (equal to one of C<$Sys::Guestfs::EVENT_*>).

=item $event_handle

The event handle.

=item $buf

For some event types, this is a message buffer (ie. a string).

=item $array

For some event types (notably progress events), this is
an array of integers.

=back

You should carefully read the documentation for
L<guestfs(3)/guestfs_set_event_callback> before using
this function.

=item $g->delete_event_callback ($event_handle);

This removes the callback which was previously registered using
C<set_event_callback>.

=item $str = Sys::Guestfs::event_to_string ($events);

C<$events> is either a single event or a bitmask of events.
This returns a printable string, useful for debugging.

Note that this is a class function, not a method.

=item $errnum = $g->last_errno ();

This returns the last error number (errno) that happened on the
handle C<$g>.

If successful, an errno integer not equal to zero is returned.

If no error number is available, this returns 0.
See L<guestfs(3)/guestfs_last_errno> for more details of why
this can happen.

You can use the standard Perl module L<Errno(3)> to compare
the numeric error returned from this call with symbolic
errnos:

 $g->mkdir ("/foo");
 if ($g->last_errno() == Errno::EEXIST()) {
   # mkdir failed because the directory exists already.
 }

=cut

=item $g->acl_delete_def_file ($dir);

This function deletes the default POSIX Access Control List (ACL)
attached to directory C<dir>.

This function depends on the feature C<acl>.  See also
C<$g-E<gt>feature-available>.

=item $acl = $g->acl_get_file ($path, $acltype);

This function returns the POSIX Access Control List (ACL) attached
to C<path>.  The ACL is returned in "long text form" (see L<acl(5)>).

The C<acltype> parameter may be:

=over 4

=item C<access>

Return the ordinary (access) ACL for any file, directory or
other filesystem object.

=item C<default>

Return the default ACL.  Normally this only makes sense if
C<path> is a directory.

=back

This function depends on the feature C<acl>.  See also
C<$g-E<gt>feature-available>.

=item $g->acl_set_file ($path, $acltype, $acl);

This function sets the POSIX Access Control List (ACL) attached
to C<path>.

The C<acltype> parameter may be:

=over 4

=item C<access>

Set the ordinary (access) ACL for any file, directory or
other filesystem object.

=item C<default>

Set the default ACL.  Normally this only makes sense if
C<path> is a directory.

=back

The C<acl> parameter is the new ACL in either "long text form"
or "short text form" (see L<acl(5)>).  The new ACL completely
replaces any previous ACL on the file.  The ACL must contain the
full Unix permissions (eg. C<u::rwx,g::rx,o::rx>).

If you are specifying individual users or groups, then the
mask field is also required (eg. C<m::rwx>), followed by the
C<u:I<ID>:...> and/or C<g:I<ID>:...> field(s).  A full ACL
string might therefore look like this:

 u::rwx,g::rwx,o::rwx,m::rwx,u:500:rwx,g:500:rwx
 \ Unix permissions / \mask/ \      ACL        /

You should use numeric UIDs and GIDs.  To map usernames and
groupnames to the correct numeric ID in the context of the
guest, use the Augeas functions (see C<$g-E<gt>aug_init>).

This function depends on the feature C<acl>.  See also
C<$g-E<gt>feature-available>.

=item $g->add_cdrom ($filename);

This function adds a virtual CD-ROM disk image to the guest.

The image is added as read-only drive, so this function is equivalent
of C<$g-E<gt>add_drive_ro>.

I<This function is deprecated.>
In new code, use the L</add_drive_ro> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $nrdisks = $g->add_domain ($dom [, libvirturi => $libvirturi] [, readonly => $readonly] [, iface => $iface] [, live => $live] [, allowuuid => $allowuuid] [, readonlydisk => $readonlydisk] [, cachemode => $cachemode] [, discard => $discard] [, copyonread => $copyonread]);

This function adds the disk(s) attached to the named libvirt
domain C<dom>.  It works by connecting to libvirt, requesting
the domain and domain XML from libvirt, parsing it for disks,
and calling C<$g-E<gt>add_drive_opts> on each one.

The number of disks added is returned.  This operation is atomic:
if an error is returned, then no disks are added.

This function does some minimal checks to make sure the libvirt
domain is not running (unless C<readonly> is true).  In a future
version we will try to acquire the libvirt lock on each disk.

Disks must be accessible locally.  This often means that adding disks
from a remote libvirt connection (see L<https://libvirt.org/remote.html>)
will fail unless those disks are accessible via the same device path
locally too.

The optional C<libvirturi> parameter sets the libvirt URI
(see L<https://libvirt.org/uri.html>).  If this is not set then
we connect to the default libvirt URI (or one set through an
environment variable, see the libvirt documentation for full
details).

The optional C<live> flag is ignored in libguestfs E<ge> 1.48.

If the C<allowuuid> flag is true (default is false) then a UUID
I<may> be passed instead of the domain name.  The C<dom> string is
treated as a UUID first and looked up, and if that lookup fails
then we treat C<dom> as a name as usual.

The optional C<readonlydisk> parameter controls what we do for
disks which are marked E<lt>readonly/E<gt> in the libvirt XML.
Possible values are:

=over 4

=item readonlydisk = "error"

If C<readonly> is false:

The whole call is aborted with an error if any disk with
the E<lt>readonly/E<gt> flag is found.

If C<readonly> is true:

Disks with the E<lt>readonly/E<gt> flag are added read-only.

=item readonlydisk = "read"

If C<readonly> is false:

Disks with the E<lt>readonly/E<gt> flag are added read-only.
Other disks are added read/write.

If C<readonly> is true:

Disks with the E<lt>readonly/E<gt> flag are added read-only.

=item readonlydisk = "write" (default)

If C<readonly> is false:

Disks with the E<lt>readonly/E<gt> flag are added read/write.

If C<readonly> is true:

Disks with the E<lt>readonly/E<gt> flag are added read-only.

=item readonlydisk = "ignore"

If C<readonly> is true or false:

Disks with the E<lt>readonly/E<gt> flag are skipped.

=back

If present, the value of C<logical_block_size> attribute of E<lt>blockio/E<gt>
tag in libvirt XML will be passed as C<blocksize> parameter to
C<$g-E<gt>add_drive_opts>.

The other optional parameters are passed directly through to
C<$g-E<gt>add_drive_opts>.

=item $g->add_drive ($filename [, readonly => $readonly] [, format => $format] [, iface => $iface] [, name => $name] [, label => $label] [, protocol => $protocol] [, server => $server] [, username => $username] [, secret => $secret] [, cachemode => $cachemode] [, discard => $discard] [, copyonread => $copyonread] [, blocksize => $blocksize]);

This function adds a disk image called F<filename> to the handle.
F<filename> may be a regular host file or a host device.

When this function is called before C<$g-E<gt>launch> (the
usual case) then the first time you call this function,
the disk appears in the API as F</dev/sda>, the second time
as F</dev/sdb>, and so on.

You don't necessarily need to be root when using libguestfs.  However
you obviously do need sufficient permissions to access the filename
for whatever operations you want to perform (ie. read access if you
just want to read the image or write access if you want to modify the
image).

This call checks that F<filename> exists.

F<filename> may be the special string C<"/dev/null">.
See L<guestfs(3)/NULL DISKS>.

The optional arguments are:

=over 4

=item C<readonly>

If true then the image is treated as read-only.  Writes are still
allowed, but they are stored in a temporary snapshot overlay which
is discarded at the end.  The disk that you add is not modified.

=item C<format>

This forces the image format.  If you omit this (or use C<$g-E<gt>add_drive>
or C<$g-E<gt>add_drive_ro>) then the format is automatically detected.
Possible formats include C<raw> and C<qcow2>.

Automatic detection of the format opens you up to a potential
security hole when dealing with untrusted raw-format images.
See CVE-2010-3851 and RHBZ#642934.  Specifying the format closes
this security hole.

=item C<iface>

This rarely-used option lets you emulate the behaviour of the
deprecated C<$g-E<gt>add_drive_with_if> call (q.v.)

=item C<name>

This field used to be passed as a hint for guest inspection, but
it is no longer used.

=item C<label>

Give the disk a label.  The label should be a unique, short
string using I<only> ASCII characters C<[a-zA-Z]>.
As well as its usual name in the API (such as F</dev/sda>),
the drive will also be named F</dev/disk/guestfs/I<label>>.

See L<guestfs(3)/DISK LABELS>.

=item C<protocol>

The optional protocol argument can be used to select an alternate
source protocol.

See also: L<guestfs(3)/REMOTE STORAGE>.

=over 4

=item C<protocol = "file">

F<filename> is interpreted as a local file or device.
This is the default if the optional protocol parameter
is omitted.

=item C<protocol = "ftp"|"ftps"|"http"|"https">

Connect to a remote FTP or HTTP server.
The C<server> parameter must also be supplied - see below.

See also: L<guestfs(3)/FTP AND HTTP>

=item C<protocol = "iscsi">

Connect to the iSCSI server.
The C<server> parameter must also be supplied - see below.
The C<username> parameter may be supplied.  See below.
The C<secret> parameter may be supplied.  See below.

See also: L<guestfs(3)/ISCSI>.

=item C<protocol = "nbd">

Connect to the Network Block Device server.
The C<server> parameter must also be supplied - see below.

See also: L<guestfs(3)/NETWORK BLOCK DEVICE>.

=item C<protocol = "rbd">

Connect to the Ceph (librbd/RBD) server.
The C<server> parameter must also be supplied - see below.
The C<username> parameter may be supplied.  See below.
The C<secret> parameter may be supplied.  See below.

See also: L<guestfs(3)/CEPH>.

=item C<protocol = "ssh">

Connect to the Secure Shell (ssh) server.

The C<server> parameter must be supplied.
The C<username> parameter may be supplied.  See below.

See also: L<guestfs(3)/SSH>.

=back

=item C<server>

For protocols which require access to a remote server, this
is a list of server(s).

 Protocol       Number of servers required
 --------       --------------------------
 file           List must be empty or param not used at all
 ftp|ftps|http|https  Exactly one
 iscsi          Exactly one
 nbd            Exactly one
 rbd            Zero or more
 ssh            Exactly one

Each list element is a string specifying a server.  The string must be
in one of the following formats:

 hostname
 hostname:port
 tcp:hostname
 tcp:hostname:port
 unix:/path/to/socket

If the port number is omitted, then the standard port number
for the protocol is used (see F</etc/services>).

=item C<username>

For the C<ftp>, C<ftps>, C<http>, C<https>, C<iscsi>, C<rbd> and C<ssh>
protocols, this specifies the remote username.

If not given, then the local username is used for C<ssh>, and no authentication
is attempted for ceph.  But note this sometimes may give unexpected results, for
example if using the libvirt backend and if the libvirt backend is configured to
start the qemu appliance as a special user such as C<qemu.qemu>.  If in doubt,
specify the remote username you want.

=item C<secret>

For the C<rbd> protocol only, this specifies the ‘secret’ to use when
connecting to the remote device.  It must be base64 encoded.

If not given, then a secret matching the given username will be looked up in the
default keychain locations, or if no username is given, then no authentication
will be used.

=item C<cachemode>

Choose whether or not libguestfs will obey sync operations (safe but slow)
or not (unsafe but fast).  The possible values for this string are:

=over 4

=item C<cachemode = "writeback">

This is the default.

Write operations in the API do not return until a L<write(2)>
call has completed in the host [but note this does not imply
that anything gets written to disk].

Sync operations in the API, including implicit syncs caused by
filesystem journalling, will not return until an L<fdatasync(2)>
call has completed in the host, indicating that data has been
committed to disk.

=item C<cachemode = "unsafe">

In this mode, there are no guarantees.  Libguestfs may cache
anything and ignore sync requests.  This is suitable only
for scratch or temporary disks.

=back

=item C<discard>

Enable or disable discard (a.k.a. trim or unmap) support on this
drive.  If enabled, operations such as C<$g-E<gt>fstrim> will be able
to discard / make thin / punch holes in the underlying host file
or device.

Possible discard settings are:

=over 4

=item C<discard = "disable">

Disable discard support.  This is the default.

=item C<discard = "enable">

Enable discard support.  Fail if discard is not possible.

=item C<discard = "besteffort">

Enable discard support if possible, but don't fail if it is not
supported.

Since not all backends and not all underlying systems support
discard, this is a good choice if you want to use discard if
possible, but don't mind if it doesn't work.

=back

=item C<copyonread>

The boolean parameter C<copyonread> enables copy-on-read support.
This only affects disk formats which have backing files, and causes
reads to be stored in the overlay layer, speeding up multiple reads
of the same area of disk.

The default is false.

=item C<blocksize>

This parameter sets the sector size of the disk.  Possible values are
C<512> (the default if the parameter is omitted) or C<4096>.  Use
C<4096> when handling an "Advanced Format" disk that uses 4K sector
size (L<https://en.wikipedia.org/wiki/Advanced_Format>).

Only a subset of the backends support this parameter (currently only the
libvirt and direct backends do).

=back

=item $g->add_drive_opts ($filename [, readonly => $readonly] [, format => $format] [, iface => $iface] [, name => $name] [, label => $label] [, protocol => $protocol] [, server => $server] [, username => $username] [, secret => $secret] [, cachemode => $cachemode] [, discard => $discard] [, copyonread => $copyonread] [, blocksize => $blocksize]);

This is an alias of L</add_drive>.

=cut

sub add_drive_opts {
  &add_drive (@_)
}

=pod

=item $g->add_drive_ro ($filename);

This function is the equivalent of calling C<$g-E<gt>add_drive_opts>
with the optional parameter C<GUESTFS_ADD_DRIVE_OPTS_READONLY> set to 1,
so the disk is added read-only, with the format being detected
automatically.

=item $g->add_drive_ro_with_if ($filename, $iface);

This is the same as C<$g-E<gt>add_drive_ro> but it allows you
to specify the QEMU interface emulation to use at run time.
Both the direct and the libvirt backends ignore C<iface>.

I<This function is deprecated.>
In new code, use the L</add_drive> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->add_drive_scratch ($size [, name => $name] [, label => $label] [, blocksize => $blocksize]);

This command adds a temporary scratch drive to the handle.  The
C<size> parameter is the virtual size (in bytes).  The scratch
drive is blank initially (all reads return zeroes until you start
writing to it).  The drive is deleted when the handle is closed.

The optional arguments C<name>, C<label> and C<blocksize> are passed through to
C<$g-E<gt>add_drive_opts>.

=item $g->add_drive_with_if ($filename, $iface);

This is the same as C<$g-E<gt>add_drive> but it allows you
to specify the QEMU interface emulation to use at run time.
Both the direct and the libvirt backends ignore C<iface>.

I<This function is deprecated.>
In new code, use the L</add_drive> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $nrdisks = $g->add_libvirt_dom ($dom [, readonly => $readonly] [, iface => $iface] [, live => $live] [, readonlydisk => $readonlydisk] [, cachemode => $cachemode] [, discard => $discard] [, copyonread => $copyonread]);

This function adds the disk(s) attached to the libvirt domain C<dom>.
It works by requesting the domain XML from libvirt, parsing it for
disks, and calling C<$g-E<gt>add_drive_opts> on each one.

In the C API we declare C<void *dom>, but really it has type
C<virDomainPtr dom>.  This is so we don't need E<lt>libvirt.hE<gt>.

The number of disks added is returned.  This operation is atomic:
if an error is returned, then no disks are added.

This function does some minimal checks to make sure the libvirt
domain is not running (unless C<readonly> is true).  In a future
version we will try to acquire the libvirt lock on each disk.

Disks must be accessible locally.  This often means that adding disks
from a remote libvirt connection (see L<https://libvirt.org/remote.html>)
will fail unless those disks are accessible via the same device path
locally too.

The optional C<live> flag is ignored in libguestfs E<ge> 1.48.

The optional C<readonlydisk> parameter controls what we do for
disks which are marked E<lt>readonly/E<gt> in the libvirt XML.
See C<$g-E<gt>add_domain> for possible values.

If present, the value of C<logical_block_size> attribute of E<lt>blockio/E<gt>
tag in libvirt XML will be passed as C<blocksize> parameter to
C<$g-E<gt>add_drive_opts>.

The other optional parameters are passed directly through to
C<$g-E<gt>add_drive_opts>.

=item $g->aug_clear ($augpath);

Set the value associated with C<path> to C<NULL>.  This
is the same as the L<augtool(1)> C<clear> command.

=item $g->aug_close ();

Close the current Augeas handle and free up any resources
used by it.  After calling this, you have to call
C<$g-E<gt>aug_init> again before you can use any other
Augeas functions.

=item %nrnodescreated = $g->aug_defnode ($name, $expr, $val);

Defines a variable C<name> whose value is the result of
evaluating C<expr>.

If C<expr> evaluates to an empty nodeset, a node is created,
equivalent to calling C<$g-E<gt>aug_set> C<expr>, C<val>.
C<name> will be the nodeset containing that single node.

On success this returns a pair containing the
number of nodes in the nodeset, and a boolean flag
if a node was created.

=item $nrnodes = $g->aug_defvar ($name, $expr);

Defines an Augeas variable C<name> whose value is the result
of evaluating C<expr>.  If C<expr> is NULL, then C<name> is
undefined.

On success this returns the number of nodes in C<expr>, or
C<0> if C<expr> evaluates to something which is not a nodeset.

=item $val = $g->aug_get ($augpath);

Look up the value associated with C<path>.  If C<path>
matches exactly one node, the C<value> is returned.

=item $g->aug_init ($root, $flags);

Create a new Augeas handle for editing configuration files.
If there was any previous Augeas handle associated with this
guestfs session, then it is closed.

You must call this before using any other C<$g-E<gt>aug_*>
commands.

C<root> is the filesystem root.  C<root> must not be NULL,
use F</> instead.

The flags are the same as the flags defined in
E<lt>augeas.hE<gt>, the logical I<or> of the following
integers:

=over 4

=item C<AUG_SAVE_BACKUP> = 1

Keep the original file with a C<.augsave> extension.

=item C<AUG_SAVE_NEWFILE> = 2

Save changes into a file with extension C<.augnew>, and
do not overwrite original.  Overrides C<AUG_SAVE_BACKUP>.

=item C<AUG_TYPE_CHECK> = 4

Typecheck lenses.

This option is only useful when debugging Augeas lenses.  Use
of this option may require additional memory for the libguestfs
appliance.  You may need to set the C<LIBGUESTFS_MEMSIZE>
environment variable or call C<$g-E<gt>set_memsize>.

=item C<AUG_NO_STDINC> = 8

Do not use standard load path for modules.

=item C<AUG_SAVE_NOOP> = 16

Make save a no-op, just record what would have been changed.

=item C<AUG_NO_LOAD> = 32

Do not load the tree in C<$g-E<gt>aug_init>.

=back

To close the handle, you can call C<$g-E<gt>aug_close>.

To find out more about Augeas, see L<http://augeas.net/>.

=item $g->aug_insert ($augpath, $label, $before);

Create a new sibling C<label> for C<path>, inserting it into
the tree before or after C<path> (depending on the boolean
flag C<before>).

C<path> must match exactly one existing node in the tree, and
C<label> must be a label, ie. not contain F</>, C<*> or end
with a bracketed index C<[N]>.

=item $label = $g->aug_label ($augpath);

The label (name of the last element) of the Augeas path expression
C<augpath> is returned.  C<augpath> must match exactly one node, else
this function returns an error.

=item $g->aug_load ();

Load files into the tree.

See C<aug_load> in the Augeas documentation for the full gory
details.

=item @matches = $g->aug_ls ($augpath);

This is just a shortcut for listing C<$g-E<gt>aug_match>
C<path/*> and sorting the resulting nodes into alphabetical order.

=item @matches = $g->aug_match ($augpath);

Returns a list of paths which match the path expression C<path>.
The returned paths are sufficiently qualified so that they match
exactly one node in the current tree.

=item $g->aug_mv ($src, $dest);

Move the node C<src> to C<dest>.  C<src> must match exactly
one node.  C<dest> is overwritten if it exists.

=item $nrnodes = $g->aug_rm ($augpath);

Remove C<path> and all of its children.

On success this returns the number of entries which were removed.

=item $g->aug_save ();

This writes all pending changes to disk.

The flags which were passed to C<$g-E<gt>aug_init> affect exactly
how files are saved.

=item $g->aug_set ($augpath, $val);

Set the value associated with C<augpath> to C<val>.

In the Augeas API, it is possible to clear a node by setting
the value to NULL.  Due to an oversight in the libguestfs API
you cannot do that with this call.  Instead you must use the
C<$g-E<gt>aug_clear> call.

=item $nodes = $g->aug_setm ($base, $sub, $val);

Change multiple Augeas nodes in a single operation.  C<base> is
an expression matching multiple nodes.  C<sub> is a path expression
relative to C<base>.  All nodes matching C<base> are found, and then
for each node, C<sub> is changed to C<val>.  C<sub> may also be C<NULL>
in which case the C<base> nodes are modified.

This returns the number of nodes modified.

=item $g->aug_transform ($lens, $file [, remove => $remove]);

Add an Augeas transformation for the specified C<lens> so it can
handle C<file>.

If C<remove> is true (C<false> by default), then the transformation
is removed.

=item $g->available (\@groups);

This command is used to check the availability of some
groups of functionality in the appliance, which not all builds of
the libguestfs appliance will be able to provide.

The libguestfs groups, and the functions that those
groups correspond to, are listed in L<guestfs(3)/AVAILABILITY>.
You can also fetch this list at runtime by calling
C<$g-E<gt>available_all_groups>.

The argument C<groups> is a list of group names, eg:
C<["inotify", "augeas"]> would check for the availability of
the Linux inotify functions and Augeas (configuration file
editing) functions.

The command returns no error if I<all> requested groups are available.

It fails with an error if one or more of the requested
groups is unavailable in the appliance.

If an unknown group name is included in the
list of groups then an error is always returned.

I<Notes:>

=over 4

=item *

C<$g-E<gt>feature_available> is the same as this call, but
with a slightly simpler to use API: that call returns a boolean
true/false instead of throwing an error.

=item *

You must call C<$g-E<gt>launch> before calling this function.

The reason is because we don't know what groups are
supported by the appliance/daemon until it is running and can
be queried.

=item *

If a group of functions is available, this does not necessarily
mean that they will work.  You still have to check for errors
when calling individual API functions even if they are
available.

=item *

It is usually the job of distro packagers to build
complete functionality into the libguestfs appliance.
Upstream libguestfs, if built from source with all
requirements satisfied, will support everything.

=item *

This call was added in version C<1.0.80>.  In previous
versions of libguestfs all you could do would be to speculatively
execute a command to find out if the daemon implemented it.
See also C<$g-E<gt>version>.

=back

See also C<$g-E<gt>filesystem_available>.

=item @groups = $g->available_all_groups ();

This command returns a list of all optional groups that this
daemon knows about.  Note this returns both supported and unsupported
groups.  To find out which ones the daemon can actually support
you have to call C<$g-E<gt>available> / C<$g-E<gt>feature_available>
on each member of the returned list.

See also C<$g-E<gt>available>, C<$g-E<gt>feature_available>
and L<guestfs(3)/AVAILABILITY>.

=item $g->base64_in ($base64file, $filename);

This command uploads base64-encoded data from C<base64file>
to F<filename>.

=item $g->base64_out ($filename, $base64file);

This command downloads the contents of F<filename>, writing
it out to local file C<base64file> encoded as base64.

=item $g->blkdiscard ($device);

This discards all blocks on the block device C<device>, giving
the free space back to the host.

This operation requires support in libguestfs, the host filesystem,
qemu and the host kernel.  If this support isn't present it may give
an error or even appear to run but do nothing.  You must also
set the C<discard> attribute on the underlying drive (see
C<$g-E<gt>add_drive_opts>).

This function depends on the feature C<blkdiscard>.  See also
C<$g-E<gt>feature-available>.

=item $zeroes = $g->blkdiscardzeroes ($device);

This call returns true if blocks on C<device> that have been
discarded by a call to C<$g-E<gt>blkdiscard> are returned as
blocks of zero bytes when read the next time.

If it returns false, then it may be that discarded blocks are
read as stale or random data.

This function depends on the feature C<blkdiscardzeroes>.  See also
C<$g-E<gt>feature-available>.

=item %info = $g->blkid ($device);

This command returns block device attributes for C<device>. The following fields are
usually present in the returned hash. Other fields may also be present.

=over

=item C<UUID>

The uuid of this device.

=item C<LABEL>

The label of this device.

=item C<VERSION>

The version of blkid command.

=item C<TYPE>

The filesystem type or RAID of this device.

=item C<USAGE>

The usage of this device, for example C<filesystem> or C<raid>.

=back

=item $g->blockdev_flushbufs ($device);

This tells the kernel to flush internal buffers associated
with C<device>.

This uses the L<blockdev(8)> command.

=item $blocksize = $g->blockdev_getbsz ($device);

This returns the block size of a device.

Note: this is different from both I<size in blocks> and
I<filesystem block size>.  Also this setting is not really
used by anything.  You should probably not use it for
anything.  Filesystems have their own idea about what
block size to choose.

This uses the L<blockdev(8)> command.

=item $ro = $g->blockdev_getro ($device);

Returns a boolean indicating if the block device is read-only
(true if read-only, false if not).

This uses the L<blockdev(8)> command.

=item $sizeinbytes = $g->blockdev_getsize64 ($device);

This returns the size of the device in bytes.

See also C<$g-E<gt>blockdev_getsz>.

This uses the L<blockdev(8)> command.

=item $sectorsize = $g->blockdev_getss ($device);

This returns the size of sectors on a block device.
Usually 512, but can be larger for modern devices.

(Note, this is not the size in sectors, use C<$g-E<gt>blockdev_getsz>
for that).

This uses the L<blockdev(8)> command.

=item $sizeinsectors = $g->blockdev_getsz ($device);

This returns the size of the device in units of 512-byte sectors
(even if the sectorsize isn't 512 bytes ... weird).

See also C<$g-E<gt>blockdev_getss> for the real sector size of
the device, and C<$g-E<gt>blockdev_getsize64> for the more
useful I<size in bytes>.

This uses the L<blockdev(8)> command.

=item $g->blockdev_rereadpt ($device);

Reread the partition table on C<device>.

This uses the L<blockdev(8)> command.

=item $g->blockdev_setbsz ($device, $blocksize);

This call does nothing and has never done anything
because of a bug in blockdev.  B<Do not use it.>

If you need to set the filesystem block size, use the
C<blocksize> option of C<$g-E<gt>mkfs>.

I<This function is deprecated.>
There is no replacement.  Consult the API documentation in
L<guestfs(3)> for further information.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->blockdev_setra ($device, $sectors);

Set readahead (in 512-byte sectors) for the device.

This uses the L<blockdev(8)> command.

=item $g->blockdev_setro ($device);

Sets the block device named C<device> to read-only.

This uses the L<blockdev(8)> command.

=item $g->blockdev_setrw ($device);

Sets the block device named C<device> to read-write.

This uses the L<blockdev(8)> command.

=item $g->btrfs_balance_cancel ($path);

Cancel a running balance on a btrfs filesystem.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_balance_pause ($path);

Pause a running balance on a btrfs filesystem.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_balance_resume ($path);

Resume a paused balance on a btrfs filesystem.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item %status = $g->btrfs_balance_status ($path);

Show the status of a running or paused balance on a btrfs filesystem.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_device_add (\@devices, $fs);

Add the list of device(s) in C<devices> to the btrfs filesystem
mounted at C<fs>.  If C<devices> is an empty list, this does nothing.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_device_delete (\@devices, $fs);

Remove the C<devices> from the btrfs filesystem mounted at C<fs>.
If C<devices> is an empty list, this does nothing.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_filesystem_balance ($fs);

Balance the chunks in the btrfs filesystem mounted at C<fs>
across the underlying devices.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_filesystem_defragment ($path [, flush => $flush] [, compress => $compress]);

Defragment a file or directory on a btrfs filesystem. compress is one of zlib or lzo.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_filesystem_resize ($mountpoint [, size => $size]);

This command resizes a btrfs filesystem.

Note that unlike other resize calls, the filesystem has to be
mounted and the parameter is the mountpoint not the device
(this is a requirement of btrfs itself).

The optional parameters are:

=over 4

=item C<size>

The new size (in bytes) of the filesystem.  If omitted, the filesystem
is resized to the maximum size.

=back

See also L<btrfs(8)>.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item @devices = $g->btrfs_filesystem_show ($device);

Show all the devices where the filesystems in C<device> is spanned over.

If not all the devices for the filesystems are present, then this function
fails and the C<errno> is set to C<ENODEV>.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_filesystem_sync ($fs);

Force sync on the btrfs filesystem mounted at C<fs>.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_fsck ($device [, superblock => $superblock] [, repair => $repair]);

Used to check a btrfs filesystem, C<device> is the device file where the
filesystem is stored.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_image (\@source, $image [, compresslevel => $compresslevel]);

This is used to create an image of a btrfs filesystem.
All data will be zeroed, but metadata and the like is preserved.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_qgroup_assign ($src, $dst, $path);

Add qgroup C<src> to parent qgroup C<dst>. This command can group
several qgroups into a parent qgroup to share common limit.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_qgroup_create ($qgroupid, $subvolume);

Create a quota group (qgroup) for subvolume at C<subvolume>.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_qgroup_destroy ($qgroupid, $subvolume);

Destroy a quota group.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_qgroup_limit ($subvolume, $size);

Limit the size of the subvolume with path C<subvolume>.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_qgroup_remove ($src, $dst, $path);

Remove qgroup C<src> from the parent qgroup C<dst>.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item @qgroups = $g->btrfs_qgroup_show ($path);

Show all subvolume quota groups in a btrfs filesystem, including their
usages.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_quota_enable ($fs, $enable);

Enable or disable subvolume quota support for filesystem which contains C<path>.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_quota_rescan ($fs);

Trash all qgroup numbers and scan the metadata again with the current config.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_replace ($srcdev, $targetdev, $mntpoint);

Replace device of a btrfs filesystem. On a live filesystem, duplicate the data
to the target device which is currently stored on the source device.
After completion of the operation, the source device is wiped out and
removed from the filesystem.

The C<targetdev> needs to be same size or larger than the C<srcdev>. Devices
which are currently mounted are never allowed to be used as the C<targetdev>.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_rescue_chunk_recover ($device);

Recover the chunk tree of btrfs filesystem by scanning the devices one by one.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_rescue_super_recover ($device);

Recover bad superblocks from good copies.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_scrub_cancel ($path);

Cancel a running scrub on a btrfs filesystem.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_scrub_resume ($path);

Resume a previously canceled or interrupted scrub on a btrfs filesystem.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_scrub_start ($path);

Reads all the data and metadata on the filesystem, and uses checksums
and the duplicate copies from RAID storage to identify and repair any
corrupt data.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item %status = $g->btrfs_scrub_status ($path);

Show status of running or finished scrub on a btrfs filesystem.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_set_seeding ($device, $seeding);

Enable or disable the seeding feature of a device that contains
a btrfs filesystem.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_subvolume_create ($dest [, qgroupid => $qgroupid]);

Create a btrfs subvolume.  The C<dest> argument is the destination
directory and the name of the subvolume, in the form F</path/to/dest/name>.
The optional parameter C<qgroupid> represents the qgroup which the newly
created subvolume will be added to.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_subvolume_create_opts ($dest [, qgroupid => $qgroupid]);

This is an alias of L</btrfs_subvolume_create>.

=cut

sub btrfs_subvolume_create_opts {
  &btrfs_subvolume_create (@_)
}

=pod

=item $g->btrfs_subvolume_delete ($subvolume);

Delete the named btrfs subvolume or snapshot.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $id = $g->btrfs_subvolume_get_default ($fs);

Get the default subvolume or snapshot of a filesystem mounted at C<mountpoint>.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item @subvolumes = $g->btrfs_subvolume_list ($fs);

List the btrfs snapshots and subvolumes of the btrfs filesystem
which is mounted at C<fs>.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_subvolume_set_default ($id, $fs);

Set the subvolume of the btrfs filesystem C<fs> which will
be mounted by default.  See C<$g-E<gt>btrfs_subvolume_list> to
get a list of subvolumes.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item %btrfssubvolumeinfo = $g->btrfs_subvolume_show ($subvolume);

Return detailed information of the subvolume.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_subvolume_snapshot ($source, $dest [, ro => $ro] [, qgroupid => $qgroupid]);

Create a snapshot of the btrfs subvolume C<source>.
The C<dest> argument is the destination directory and the name
of the snapshot, in the form F</path/to/dest/name>. By default
the newly created snapshot is writable, if the value of optional
parameter C<ro> is true, then a readonly snapshot is created. The
optional parameter C<qgroupid> represents the qgroup which the
newly created snapshot will be added to.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfs_subvolume_snapshot_opts ($source, $dest [, ro => $ro] [, qgroupid => $qgroupid]);

This is an alias of L</btrfs_subvolume_snapshot>.

=cut

sub btrfs_subvolume_snapshot_opts {
  &btrfs_subvolume_snapshot (@_)
}

=pod

=item $g->btrfstune_enable_extended_inode_refs ($device);

This will Enable extended inode refs.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfstune_enable_skinny_metadata_extent_refs ($device);

This enable skinny metadata extent refs.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->btrfstune_seeding ($device, $seeding);

Enable seeding of a btrfs device, this will force a fs readonly
so that you can use it to build other filesystems.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $ptr = $g->c_pointer ();

In non-C language bindings, this allows you to retrieve the underlying
C pointer to the handle (ie. C<$g-E<gt>h *>).  The purpose of this is
to allow other libraries to interwork with libguestfs.

=item $canonical = $g->canonical_device_name ($device);

This utility function is useful when displaying device names to
the user.  It takes a number of irregular device names and
returns them in a consistent format:

=over 4

=item F</dev/hdX>

=item F</dev/vdX>

These are returned as F</dev/sdX>.  Note this works for device
names and partition names.  This is approximately the reverse of
the algorithm described in L<guestfs(3)/BLOCK DEVICE NAMING>.

=item F</dev/mapper/VG-LV>

=item F</dev/dm-N>

Converted to F</dev/VG/LV> form using C<$g-E<gt>lvm_canonical_lv_name>.

=back

Other strings are returned unmodified.

=item $cap = $g->cap_get_file ($path);

This function returns the Linux capabilities attached to C<path>.
The capabilities set is returned in text form (see L<cap_to_text(3)>).

If no capabilities are attached to a file, an empty string is returned.

This function depends on the feature C<linuxcaps>.  See also
C<$g-E<gt>feature-available>.

=item $g->cap_set_file ($path, $cap);

This function sets the Linux capabilities attached to C<path>.
The capabilities set C<cap> should be passed in text form
(see L<cap_from_text(3)>).

This function depends on the feature C<linuxcaps>.  See also
C<$g-E<gt>feature-available>.

=item $rpath = $g->case_sensitive_path ($path);

This can be used to resolve case insensitive paths on
a filesystem which is case sensitive.  The use case is
to resolve paths which you have read from Windows configuration
files or the Windows Registry, to the true path.

The command handles a peculiarity of the Linux ntfs-3g
filesystem driver (and probably others), which is that although
the underlying filesystem is case-insensitive, the driver
exports the filesystem to Linux as case-sensitive.

One consequence of this is that special directories such
as F<C:\windows> may appear as F</WINDOWS> or F</windows>
(or other things) depending on the precise details of how
they were created.  In Windows itself this would not be
a problem.

Bug or feature?  You decide:
L<https://www.tuxera.com/community/ntfs-3g-faq/#posixfilenames1>

C<$g-E<gt>case_sensitive_path> attempts to resolve the true case of
each element in the path. It will return a resolved path if either the
full path or its parent directory exists. If the parent directory
exists but the full path does not, the case of the parent directory
will be correctly resolved, and the remainder appended unmodified. For
example, if the file C<"/Windows/System32/netkvm.sys"> exists:

=over 4

=item C<$g-E<gt>case_sensitive_path> ("/windows/system32/netkvm.sys")

"Windows/System32/netkvm.sys"

=item C<$g-E<gt>case_sensitive_path> ("/windows/system32/NoSuchFile")

"Windows/System32/NoSuchFile"

=item C<$g-E<gt>case_sensitive_path> ("/windows/system33/netkvm.sys")

I<ERROR>

=back

I<Note>:
Because of the above behaviour, C<$g-E<gt>case_sensitive_path> cannot
be used to check for the existence of a file.

I<Note>:
This function does not handle drive names, backslashes etc.

See also C<$g-E<gt>realpath>.

=item $content = $g->cat ($path);

Return the contents of the file named C<path>.

Because, in C, this function returns a C<char *>, there is no
way to differentiate between a C<\0> character in a file and
end of string.  To handle binary files, use the C<$g-E<gt>read_file>
or C<$g-E<gt>download> functions.

=item $checksum = $g->checksum ($csumtype, $path);

This call computes the MD5, SHAx or CRC checksum of the
file named C<path>.

The type of checksum to compute is given by the C<csumtype>
parameter which must have one of the following values:

=over 4

=item C<crc>

Compute the cyclic redundancy check (CRC) specified by POSIX
for the C<cksum> command.

=item C<gost>

=item C<gost12>

Compute the checksum using GOST R34.11-94 or
GOST R34.11-2012 message digest.

=item C<md5>

Compute the MD5 hash (using the L<md5sum(1)> program).

=item C<sha1>

Compute the SHA1 hash (using the L<sha1sum(1)> program).

=item C<sha224>

Compute the SHA224 hash (using the L<sha224sum(1)> program).

=item C<sha256>

Compute the SHA256 hash (using the L<sha256sum(1)> program).

=item C<sha384>

Compute the SHA384 hash (using the L<sha384sum(1)> program).

=item C<sha512>

Compute the SHA512 hash (using the L<sha512sum(1)> program).

=back

The checksum is returned as a printable string.

To get the checksum for a device, use C<$g-E<gt>checksum_device>.

To get the checksums for many files, use C<$g-E<gt>checksums_out>.

=item $checksum = $g->checksum_device ($csumtype, $device);

This call computes the MD5, SHAx or CRC checksum of the
contents of the device named C<device>.  For the types of
checksums supported see the C<$g-E<gt>checksum> command.

=item $g->checksums_out ($csumtype, $directory, $sumsfile);

This command computes the checksums of all regular files in
F<directory> and then emits a list of those checksums to
the local output file C<sumsfile>.

This can be used for verifying the integrity of a virtual
machine.  However to be properly secure you should pay
attention to the output of the checksum command (it uses
the ones from GNU coreutils).  In particular when the
filename is not printable, coreutils uses a special
backslash syntax.  For more information, see the GNU
coreutils info file.

=item $g->chmod ($mode, $path);

Change the mode (permissions) of C<path> to C<mode>.  Only
numeric modes are supported.

I<Note>: When using this command from guestfish, C<mode>
by default would be decimal, unless you prefix it with
C<0> to get octal, ie. use C<0700> not C<700>.

The mode actually set is affected by the umask.

=item $g->chown ($owner, $group, $path);

Change the file owner to C<owner> and group to C<group>.

Only numeric uid and gid are supported.  If you want to use
names, you will need to locate and parse the password file
yourself (Augeas support makes this relatively easy).

=item $count = $g->clear_backend_setting ($name);

If there is a backend setting string matching C<"name"> or
beginning with C<"name=">, then that string is removed
from the backend settings.

This call returns the number of strings which were removed
(which may be 0, 1 or greater than 1).

See L<guestfs(3)/BACKEND>, L<guestfs(3)/BACKEND SETTINGS>.

=item $g->clevis_luks_unlock ($device, $mapname);

This command opens a block device that has been encrypted according to
the Linux Unified Key Setup (LUKS) standard, using network-bound disk
encryption (NBDE).

C<device> is the encrypted block device.

The appliance will connect to the Tang servers noted in the tree of
Clevis pins that is bound to a keyslot of the LUKS header.  The Clevis
pin tree may comprise C<sss> (redudancy) pins as internal nodes
(optionally), and C<tang> pins as leaves.  C<tpm2> pins are not
supported.  The appliance unlocks the encrypted block device by
combining responses from the Tang servers with metadata from the LUKS
header; there is no C<key> parameter.

This command will fail if networking has not been enabled for the
appliance. Refer to C<$g-E<gt>set_network>.

The command creates a new block device called F</dev/mapper/mapname>.
Reads and writes to this block device are decrypted from and encrypted
to the underlying C<device> respectively.  Close the decrypted block
device with C<$g-E<gt>cryptsetup_close>.

C<mapname> cannot be C<"control"> because that name is reserved by
device-mapper.

If this block device contains LVM volume groups, then calling
C<$g-E<gt>lvm_scan> with the C<activate> parameter C<true> will make
them visible.

Use C<$g-E<gt>list_dm_devices> to list all device mapper devices.

This function depends on the feature C<clevisluks>.  See also
C<$g-E<gt>feature-available>.

=item $output = $g->command (\@arguments);

This call runs a command from the guest filesystem.  The
filesystem must be mounted, and must contain a compatible
operating system (ie. something Linux, with the same
or compatible processor architecture).

The single parameter is an argv-style list of arguments.
The first element is the name of the program to run.
Subsequent elements are parameters.  The list must be
non-empty (ie. must contain a program name).  Note that
the command runs directly, and is I<not> invoked via
the shell (see C<$g-E<gt>sh>).

The return value is anything printed to I<stdout> by
the command.

If the command returns a non-zero exit status, then
this function returns an error message.  The error message
string is the content of I<stderr> from the command.

The C<$PATH> environment variable will contain at least
F</usr/bin> and F</bin>.  If you require a program from
another location, you should provide the full path in the
first parameter.

Shared libraries and data files required by the program
must be available on filesystems which are mounted in the
correct places.  It is the caller’s responsibility to ensure
all filesystems that are needed are mounted at the right
locations.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

=item @lines = $g->command_lines (\@arguments);

This is the same as C<$g-E<gt>command>, but splits the
result into a list of lines.

See also: C<$g-E<gt>sh_lines>

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

=item $g->compress_device_out ($ctype, $device, $zdevice [, level => $level]);

This command compresses C<device> and writes it out to the local
file C<zdevice>.

The C<ctype> and optional C<level> parameters have the same meaning
as in C<$g-E<gt>compress_out>.

=item $g->compress_out ($ctype, $file, $zfile [, level => $level]);

This command compresses F<file> and writes it out to the local
file F<zfile>.

The compression program used is controlled by the C<ctype> parameter.
Currently this includes: C<compress>, C<gzip>, C<bzip2>, C<xz> or C<lzop>.
Some compression types may not be supported by particular builds of
libguestfs, in which case you will get an error containing the
substring "not supported".

The optional C<level> parameter controls compression level.  The
meaning and default for this parameter depends on the compression
program being used.

=item $g->config ($hvparam, $hvvalue);

This can be used to add arbitrary hypervisor parameters of the
form I<-param value>.  Actually it’s not quite arbitrary - we
prevent you from setting some parameters which would interfere with
parameters that we use.

The first character of C<hvparam> string must be a C<-> (dash).

C<hvvalue> can be NULL.

=item $g->copy_attributes ($src, $dest [, all => $all] [, mode => $mode] [, xattributes => $xattributes] [, ownership => $ownership]);

Copy the attributes of a path (which can be a file or a directory)
to another path.

By default B<no> attribute is copied, so make sure to specify any
(or C<all> to copy everything).

The optional arguments specify which attributes can be copied:

=over 4

=item C<mode>

Copy part of the file mode from C<source> to C<destination>. Only the
UNIX permissions and the sticky/setuid/setgid bits can be copied.

=item C<xattributes>

Copy the Linux extended attributes (xattrs) from C<source> to C<destination>.
This flag does nothing if the I<linuxxattrs> feature is not available
(see C<$g-E<gt>feature_available>).

=item C<ownership>

Copy the owner uid and the group gid of C<source> to C<destination>.

=item C<all>

Copy B<all> the attributes from C<source> to C<destination>. Enabling it
enables all the other flags, if they are not specified already.

=back

=item $g->copy_device_to_device ($src, $dest [, srcoffset => $srcoffset] [, destoffset => $destoffset] [, size => $size] [, sparse => $sparse] [, append => $append]);

The four calls C<$g-E<gt>copy_device_to_device>,
C<$g-E<gt>copy_device_to_file>,
C<$g-E<gt>copy_file_to_device>, and
C<$g-E<gt>copy_file_to_file>
let you copy from a source (device|file) to a destination
(device|file).

Partial copies can be made since you can specify optionally
the source offset, destination offset and size to copy.  These
values are all specified in bytes.  If not given, the offsets
both default to zero, and the size defaults to copying as much
as possible until we hit the end of the source.

The source and destination may be the same object.  However
overlapping regions may not be copied correctly.

If the destination is a file, it is created if required.  If
the destination file is not large enough, it is extended.

If the destination is a file and the C<append> flag is not set,
then the destination file is truncated.  If the C<append> flag is
set, then the copy appends to the destination file.  The C<append>
flag currently cannot be set for devices.

If the C<sparse> flag is true then the call avoids writing
blocks that contain only zeroes, which can help in some situations
where the backing disk is thin-provisioned.  Note that unless
the target is already zeroed, using this option will result
in incorrect copying.

=item $g->copy_device_to_file ($src, $dest [, srcoffset => $srcoffset] [, destoffset => $destoffset] [, size => $size] [, sparse => $sparse] [, append => $append]);

See C<$g-E<gt>copy_device_to_device> for a general overview
of this call.

=item $g->copy_file_to_device ($src, $dest [, srcoffset => $srcoffset] [, destoffset => $destoffset] [, size => $size] [, sparse => $sparse] [, append => $append]);

See C<$g-E<gt>copy_device_to_device> for a general overview
of this call.

=item $g->copy_file_to_file ($src, $dest [, srcoffset => $srcoffset] [, destoffset => $destoffset] [, size => $size] [, sparse => $sparse] [, append => $append]);

See C<$g-E<gt>copy_device_to_device> for a general overview
of this call.

This is B<not> the function you want for copying files.  This
is for copying blocks within existing files.  See C<$g-E<gt>cp>,
C<$g-E<gt>cp_a> and C<$g-E<gt>mv> for general file copying and
moving functions.

=item $g->copy_in ($localpath, $remotedir);

C<$g-E<gt>copy_in> copies local files or directories recursively into
the disk image, placing them in the directory called C<remotedir>
(which must exist).

Wildcards cannot be used.

=item $g->copy_out ($remotepath, $localdir);

C<$g-E<gt>copy_out> copies remote files or directories recursively
out of the disk image, placing them on the host disk in a local
directory called C<localdir> (which must exist).

To download to the current directory, use C<.> as in:

 C<$g-E<gt>copy_out> /home .

Wildcards cannot be used.

=item $g->copy_size ($src, $dest, $size);

This command copies exactly C<size> bytes from one source device
or file C<src> to another destination device or file C<dest>.

Note this will fail if the source is too short or if the destination
is not large enough.

I<This function is deprecated.>
In new code, use the L</copy_device_to_device> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->cp ($src, $dest);

This copies a file from C<src> to C<dest> where C<dest> is
either a destination filename or destination directory.

=item $g->cp_a ($src, $dest);

This copies a file or directory from C<src> to C<dest>
recursively using the C<cp -a> command.

=item $g->cp_r ($src, $dest);

This copies a file or directory from C<src> to C<dest>
recursively using the C<cp -rP> command.

Most users should use C<$g-E<gt>cp_a> instead.  This command
is useful when you don't want to preserve permissions, because
the target filesystem does not support it (primarily when
writing to DOS FAT filesystems).

=item $g->cpio_out ($directory, $cpiofile [, format => $format]);

This command packs the contents of F<directory> and downloads
it to local file C<cpiofile>.

The optional C<format> parameter can be used to select the format.
Only the following formats are currently permitted:

=over 4

=item C<newc>

New (SVR4) portable format.  This format happens to be compatible
with the cpio-like format used by the Linux kernel for initramfs.

This is the default format.

=item C<crc>

New (SVR4) portable format with a checksum.

=back

=item $g->cryptsetup_close ($device);

This closes an encrypted device that was created earlier by
C<$g-E<gt>cryptsetup_open>.  The C<device> parameter must be
the name of the mapping device (ie. F</dev/mapper/mapname>)
and I<not> the name of the underlying block device.

This function depends on the feature C<luks>.  See also
C<$g-E<gt>feature-available>.

=item $g->cryptsetup_open ($device, $key, $mapname [, readonly => $readonly] [, crypttype => $crypttype] [, cipher => $cipher]);

This command opens a block device which has been encrypted
according to the Linux Unified Key Setup (LUKS) standard,
Windows BitLocker, or some other types.

C<device> is the encrypted block device or partition.

The caller must supply one of the keys associated with the
encrypted block device, in the C<key> parameter.

This creates a new block device called F</dev/mapper/mapname>.
Reads and writes to this block device are decrypted from and
encrypted to the underlying C<device> respectively.

C<mapname> cannot be C<"control"> because that name is reserved
by device-mapper.

If the optional C<crypttype> parameter is not present then
libguestfs tries to guess the correct type (for example
LUKS or BitLocker).  However you can override this by
specifying one of the following types:

=over 4

=item C<luks>

A Linux LUKS device.

=item C<bitlk>

A Windows BitLocker device.

=back

The optional C<readonly> flag, if set to true, creates a
read-only mapping.

The optional C<cipher> parameter allows specifying which
cipher to use.

If this block device contains LVM volume groups, then
calling C<$g-E<gt>lvm_scan> with the C<activate>
parameter C<true> will make them visible.

Use C<$g-E<gt>list_dm_devices> to list all device mapper
devices.

This function depends on the feature C<luks>.  See also
C<$g-E<gt>feature-available>.

=item $g->dd ($src, $dest);

This command copies from one source device or file C<src>
to another destination device or file C<dest>.  Normally you
would use this to copy to or from a device or partition, for
example to duplicate a filesystem.

If the destination is a device, it must be as large or larger
than the source file or device, otherwise the copy will fail.
This command cannot do partial copies
(see C<$g-E<gt>copy_device_to_device>).

I<This function is deprecated.>
In new code, use the L</copy_device_to_device> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $index = $g->device_index ($device);

This function takes a device name (eg. "/dev/sdb") and
returns the index of the device in the list of devices.

Index numbers start from 0.  The named device must exist,
for example as a string returned from C<$g-E<gt>list_devices>.

See also C<$g-E<gt>list_devices>, C<$g-E<gt>part_to_dev>,
C<$g-E<gt>device_name>.

=item $name = $g->device_name ($index);

This function takes a device index and returns the device
name.  For example index C<0> will return the string C</dev/sda>.

The drive index must have been added to the handle.

See also C<$g-E<gt>list_devices>, C<$g-E<gt>part_to_dev>,
C<$g-E<gt>device_index>.

=item $output = $g->df ();

This command runs the L<df(1)> command to report disk space used.

This command is mostly useful for interactive sessions.  It
is I<not> intended that you try to parse the output string.
Use C<$g-E<gt>statvfs> from programs.

=item $output = $g->df_h ();

This command runs the C<df -h> command to report disk space used
in human-readable format.

This command is mostly useful for interactive sessions.  It
is I<not> intended that you try to parse the output string.
Use C<$g-E<gt>statvfs> from programs.

=item $g->disk_create ($filename, $format, $size [, backingfile => $backingfile] [, backingformat => $backingformat] [, preallocation => $preallocation] [, compat => $compat] [, clustersize => $clustersize]);

Create a blank disk image called F<filename> (a host file)
with format C<format> (usually C<raw> or C<qcow2>).
The size is C<size> bytes.

If used with the optional C<backingfile> parameter, then a snapshot
is created on top of the backing file.  In this case, C<size> must
be passed as C<-1>.  The size of the snapshot is the same as the
size of the backing file, which is discovered automatically.  You
are encouraged to also pass C<backingformat> to describe the format
of C<backingfile>.

If F<filename> refers to a block device, then the device is
formatted.  The C<size> is ignored since block devices have an
intrinsic size.

The other optional parameters are:

=over 4

=item C<preallocation>

If format is C<raw>, then this can be either C<off> (or C<sparse>)
or C<full> to create a sparse or fully allocated file respectively.
The default is C<off>.

If format is C<qcow2>, then this can be C<off> (or C<sparse>),
C<metadata> or C<full>.  Preallocating metadata can be faster
when doing lots of writes, but uses more space.
The default is C<off>.

=item C<compat>

C<qcow2> only:
Pass the string C<1.1> to use the advanced qcow2 format supported
by qemu E<ge> 1.1.

=item C<clustersize>

C<qcow2> only:
Change the qcow2 cluster size.  The default is 65536 (bytes) and
this setting may be any power of two between 512 and 2097152.

=back

Note that this call does not add the new disk to the handle.  You
may need to call C<$g-E<gt>add_drive_opts> separately.

=item $format = $g->disk_format ($filename);

Detect and return the format of the disk image called F<filename>.
F<filename> can also be a host device, etc.  If the format of the
image could not be detected, then C<"unknown"> is returned.

Note that detecting the disk format can be insecure under some
circumstances.  See L<guestfs(3)/CVE-2010-3851>.

See also: L<guestfs(3)/DISK IMAGE FORMATS>

=item $backingfile = $g->disk_has_backing_file ($filename);

Detect and return whether the disk image F<filename> has a
backing file.

Note that detecting disk features can be insecure under some
circumstances.  See L<guestfs(3)/CVE-2010-3851>.

=item $size = $g->disk_virtual_size ($filename);

Detect and return the virtual size in bytes of the disk image
called F<filename>.

Note that detecting disk features can be insecure under some
circumstances.  See L<guestfs(3)/CVE-2010-3851>.

=item $kmsgs = $g->dmesg ();

This returns the kernel messages (L<dmesg(1)> output) from
the guest kernel.  This is sometimes useful for extended
debugging of problems.

Another way to get the same information is to enable
verbose messages with C<$g-E<gt>set_verbose> or by setting
the environment variable C<LIBGUESTFS_DEBUG=1> before
running the program.

=item $g->download ($remotefilename, $filename);

Download file F<remotefilename> and save it as F<filename>
on the local machine.

F<filename> can also be a named pipe.

See also C<$g-E<gt>upload>, C<$g-E<gt>cat>.

=item $g->download_blocks ($device, $start, $stop, $filename [, unallocated => $unallocated]);

Download the data units from F<start> address
to F<stop> from the disk partition (eg. F</dev/sda1>)
and save them as F<filename> on the local machine.

The use of this API on sparse disk image formats such as QCOW,
may result in large zero-filled files downloaded on the host.

The size of a data unit varies across filesystem implementations.
On NTFS filesystems data units are referred as clusters
while on ExtX ones they are referred as fragments.

If the optional C<unallocated> flag is true (default is false),
only the unallocated blocks will be extracted.
This is useful to detect hidden data or to retrieve deleted files
which data units have not been overwritten yet.

This function depends on the feature C<sleuthkit>.  See also
C<$g-E<gt>feature-available>.

=item $g->download_inode ($device, $inode, $filename);

Download a file given its inode from the disk partition
(eg. F</dev/sda1>) and save it as F<filename> on the local machine.

It is not required to mount the disk to run this command.

The command is capable of downloading deleted or inaccessible files.

This function depends on the feature C<sleuthkit>.  See also
C<$g-E<gt>feature-available>.

=item $g->download_offset ($remotefilename, $filename, $offset, $size);

Download file F<remotefilename> and save it as F<filename>
on the local machine.

F<remotefilename> is read for C<size> bytes starting at C<offset>
(this region must be within the file or device).

Note that there is no limit on the amount of data that
can be downloaded with this call, unlike with C<$g-E<gt>pread>,
and this call always reads the full amount unless an
error occurs.

See also C<$g-E<gt>download>, C<$g-E<gt>pread>.

=item $g->drop_caches ($whattodrop);

This instructs the guest kernel to drop its page cache,
and/or dentries and inode caches.  The parameter C<whattodrop>
tells the kernel what precisely to drop, see
L<https://linux-mm.org/Drop_Caches>

Setting C<whattodrop> to 3 should drop everything.

This automatically calls L<sync(2)> before the operation,
so that the maximum guest memory is freed.

=item $sizekb = $g->du ($path);

This command runs the C<du -s> command to estimate file space
usage for C<path>.

C<path> can be a file or a directory.  If C<path> is a directory
then the estimate includes the contents of the directory and all
subdirectories (recursively).

The result is the estimated size in I<kilobytes>
(ie. units of 1024 bytes).

=item $g->e2fsck ($device [, correct => $correct] [, forceall => $forceall]);

This runs the ext2/ext3 filesystem checker on C<device>.
It can take the following optional arguments:

=over 4

=item C<correct>

Automatically repair the file system. This option will cause e2fsck
to automatically fix any filesystem problems that can be safely
fixed without human intervention.

This option may not be specified at the same time as the C<forceall> option.

=item C<forceall>

Assume an answer of ‘yes’ to all questions; allows e2fsck to be used
non-interactively.

This option may not be specified at the same time as the C<correct> option.

=back

=item $g->e2fsck_f ($device);

This runs C<e2fsck -p -f device>, ie. runs the ext2/ext3
filesystem checker on C<device>, noninteractively (I<-p>),
even if the filesystem appears to be clean (I<-f>).

I<This function is deprecated.>
In new code, use the L</e2fsck> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $output = $g->echo_daemon (\@words);

This command concatenates the list of C<words> passed with single spaces
between them and returns the resulting string.

You can use this command to test the connection through to the daemon.

See also C<$g-E<gt>ping_daemon>.

=item @lines = $g->egrep ($regex, $path);

This calls the external L<egrep(1)> program and returns the
matching lines.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

I<This function is deprecated.>
In new code, use the L</grep> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item @lines = $g->egrepi ($regex, $path);

This calls the external C<egrep -i> program and returns the
matching lines.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

I<This function is deprecated.>
In new code, use the L</grep> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $equality = $g->equal ($file1, $file2);

This compares the two files F<file1> and F<file2> and returns
true if their content is exactly equal, or false otherwise.

The external L<cmp(1)> program is used for the comparison.

=item $existsflag = $g->exists ($path);

This returns C<true> if and only if there is a file, directory
(or anything) with the given C<path> name.

See also C<$g-E<gt>is_file>, C<$g-E<gt>is_dir>, C<$g-E<gt>stat>.

=item $g->extlinux ($directory);

Install the SYSLINUX bootloader on the device mounted at F<directory>.
Unlike C<$g-E<gt>syslinux> which requires a FAT filesystem, this can
be used on an ext2/3/4 or btrfs filesystem.

The F<directory> parameter can be either a mountpoint, or a
directory within the mountpoint.

You also have to mark the partition as "active"
(C<$g-E<gt>part_set_bootable>) and a Master Boot Record must
be installed (eg. using C<$g-E<gt>pwrite_device>) on the first
sector of the whole disk.
The SYSLINUX package comes with some suitable Master Boot Records.
See the L<extlinux(1)> man page for further information.

Additional configuration can be supplied to SYSLINUX by
placing a file called F<extlinux.conf> on the filesystem
under F<directory>.  For further information
about the contents of this file, see L<extlinux(1)>.

See also C<$g-E<gt>syslinux>.

This function depends on the feature C<extlinux>.  See also
C<$g-E<gt>feature-available>.

=item $g->f2fs_expand ($device);

This expands a f2fs filesystem to match the size of the underlying
device.

This function depends on the feature C<f2fs>.  See also
C<$g-E<gt>feature-available>.

=item $g->fallocate ($path, $len);

This command preallocates a file (containing zero bytes) named
C<path> of size C<len> bytes.  If the file exists already, it
is overwritten.

Do not confuse this with the guestfish-specific
C<alloc> command which allocates a file in the host and
attaches it as a device.

I<This function is deprecated.>
In new code, use the L</fallocate64> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->fallocate64 ($path, $len);

This command preallocates a file (containing zero bytes) named
C<path> of size C<len> bytes.  If the file exists already, it
is overwritten.

Note that this call allocates disk blocks for the file.
To create a sparse file use C<$g-E<gt>truncate_size> instead.

The deprecated call C<$g-E<gt>fallocate> does the same,
but owing to an oversight it only allowed 30 bit lengths
to be specified, effectively limiting the maximum size
of files created through that call to 1GB.

Do not confuse this with the guestfish-specific
C<alloc> and C<sparse> commands which create
a file in the host and attach it as a device.

=item $isavailable = $g->feature_available (\@groups);

This is the same as C<$g-E<gt>available>, but unlike that
call it returns a simple true/false boolean result, instead
of throwing an exception if a feature is not found.  For
other documentation see C<$g-E<gt>available>.

=item @lines = $g->fgrep ($pattern, $path);

This calls the external L<fgrep(1)> program and returns the
matching lines.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

I<This function is deprecated.>
In new code, use the L</grep> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item @lines = $g->fgrepi ($pattern, $path);

This calls the external C<fgrep -i> program and returns the
matching lines.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

I<This function is deprecated.>
In new code, use the L</grep> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $description = $g->file ($path);

This call uses the standard L<file(1)> command to determine
the type or contents of the file.

This call will also transparently look inside various types
of compressed file.

The filename is not prepended to the output
(like the file command I<-b> option).

The output depends on the output of the underlying L<file(1)>
command and it can change in future in ways beyond our control.
In other words, the output is not guaranteed by the ABI.

See also: L<file(1)>, C<$g-E<gt>vfs_type>, C<$g-E<gt>lstat>,
C<$g-E<gt>is_file>, C<$g-E<gt>is_blockdev> (etc), C<$g-E<gt>is_zero>.

=item $arch = $g->file_architecture ($filename);

This detects the architecture of the binary F<filename>,
and returns it if known.

Currently defined architectures are:

=over 4

=item "aarch64"

64 bit ARM.

=item "arm"

32 bit ARM.

=item "i386"

This string is returned for all 32 bit i386, i486, i586, i686 binaries
irrespective of the precise processor requirements of the binary.

=item "ia64"

Intel Itanium.

=item "ppc"

32 bit Power PC.

=item "ppc64"

64 bit Power PC (big endian).

=item "ppc64le"

64 bit Power PC (little endian).

=item "loongarch64"

64 bit LoongArch64 (little endian).

=item "riscv32"

=item "riscv64"

=item "riscv128"

RISC-V 32-, 64- or 128-bit variants.

=item "s390"

31 bit IBM S/390.

=item "s390x"

64 bit IBM S/390.

=item "sparc"

32 bit SPARC.

=item "sparc64"

64 bit SPARC V9 and above.

=item "x86_64"

64 bit x86-64.

=back

Libguestfs may return other architecture strings in future.

The function works on at least the following types of files:

=over 4

=item *

many types of Un*x and Linux binary

=item *

many types of Un*x and Linux shared library

=item *

Windows Win32 and Win64 binaries

=item *

Windows Win32 and Win64 DLLs

Win32 binaries and DLLs return C<i386>.

Win64 binaries and DLLs return C<x86_64>.

=item *

Linux kernel modules

=item *

Linux new-style initrd images

=item *

some non-x86 Linux vmlinuz kernels

=back

What it can't do currently:

=over 4

=item *

static libraries (libfoo.a)

=item *

Linux old-style initrd as compressed ext2 filesystem (RHEL 3)

=item *

x86 Linux vmlinuz kernels

x86 vmlinuz images (bzImage format) consist of a mix of 16-, 32- and
compressed code, and are horribly hard to unpack.  If you want to find
the architecture of a kernel, use the architecture of the associated
initrd or kernel module(s) instead.

=back

=item $size = $g->filesize ($file);

This command returns the size of F<file> in bytes.

To get other stats about a file, use C<$g-E<gt>stat>, C<$g-E<gt>lstat>,
C<$g-E<gt>is_dir>, C<$g-E<gt>is_file> etc.
To get the size of block devices, use C<$g-E<gt>blockdev_getsize64>.

=item $fsavail = $g->filesystem_available ($filesystem);

Check whether libguestfs supports the named filesystem.
The argument C<filesystem> is a filesystem name, such as
C<ext3>.

You must call C<$g-E<gt>launch> before using this command.

This is mainly useful as a negative test.  If this returns true,
it doesn't mean that a particular filesystem can be created
or mounted, since filesystems can fail for other reasons
such as it being a later version of the filesystem,
or having incompatible features, or lacking the right
mkfs.E<lt>I<fs>E<gt> tool.

See also C<$g-E<gt>available>, C<$g-E<gt>feature_available>,
L<guestfs(3)/AVAILABILITY>.

=item @dirents = $g->filesystem_walk ($device);

Walk through the internal structures of a disk partition
(eg. F</dev/sda1>) in order to return a list of all the files
and directories stored within.

It is not necessary to mount the disk partition to run this command.

All entries in the filesystem are returned. This function can list deleted
or unaccessible files. The entries are I<not> sorted.

The C<tsk_dirent> structure contains the following fields.

=over 4

=item C<tsk_inode>

Filesystem reference number of the node. It might be C<0>
if the node has been deleted.

=item C<tsk_type>

Basic file type information.
See below for a detailed list of values.

=item C<tsk_size>

File size in bytes. It might be C<-1>
if the node has been deleted.

=item C<tsk_name>

The file path relative to its directory.

=item C<tsk_flags>

Bitfield containing extra information regarding the entry.
It contains the logical OR of the following values:

=over 4

=item 0x0001

If set to C<1>, the file is allocated and visible within the filesystem.
Otherwise, the file has been deleted.
Under certain circumstances, the function C<download_inode>
can be used to recover deleted files.

=item 0x0002

Filesystem such as NTFS and Ext2 or greater, separate the file name
from the metadata structure.
The bit is set to C<1> when the file name is in an unallocated state
and the metadata structure is in an allocated one.
This generally implies the metadata has been reallocated to a new file.
Therefore, information such as file type, file size, timestamps,
number of links and symlink target might not correspond
with the ones of the original deleted entry.

=item 0x0004

The bit is set to C<1> when the file is compressed using filesystem
native compression support (NTFS). The API is not able to detect
application level compression.

=back

=item C<tsk_atime_sec>

=item C<tsk_atime_nsec>

=item C<tsk_mtime_sec>

=item C<tsk_mtime_nsec>

=item C<tsk_ctime_sec>

=item C<tsk_ctime_nsec>

=item C<tsk_crtime_sec>

=item C<tsk_crtime_nsec>

Respectively, access, modification, last status change and creation
time in Unix format in seconds and nanoseconds.

=item C<tsk_nlink>

Number of file names pointing to this entry.

=item C<tsk_link>

If the entry is a symbolic link, this field will contain the path
to the target file.

=back

The C<tsk_type> field will contain one of the following characters:

=over 4

=item 'b'

Block special

=item 'c'

Char special

=item 'd'

Directory

=item 'f'

FIFO (named pipe)

=item 'l'

Symbolic link

=item 'r'

Regular file

=item 's'

Socket

=item 'h'

Shadow inode (Solaris)

=item 'w'

Whiteout inode (BSD)

=item 'u'

Unknown file type

=back

This function depends on the feature C<libtsk>.  See also
C<$g-E<gt>feature-available>.

=item $g->fill ($c, $len, $path);

This command creates a new file called C<path>.  The initial
content of the file is C<len> octets of C<c>, where C<c>
must be a number in the range C<[0..255]>.

To fill a file with zero bytes (sparsely), it is
much more efficient to use C<$g-E<gt>truncate_size>.
To create a file with a pattern of repeating bytes
use C<$g-E<gt>fill_pattern>.

=item $g->fill_dir ($dir, $nr);

This function, useful for testing filesystems, creates C<nr>
empty files in the directory C<dir> with names C<00000000>
through C<nr-1> (ie. each file name is 8 digits long padded
with zeroes).

=item $g->fill_pattern ($pattern, $len, $path);

This function is like C<$g-E<gt>fill> except that it creates
a new file of length C<len> containing the repeating pattern
of bytes in C<pattern>.  The pattern is truncated if necessary
to ensure the length of the file is exactly C<len> bytes.

=item @names = $g->find ($directory);

This command lists out all files and directories, recursively,
starting at F<directory>.  It is essentially equivalent to
running the shell command C<find directory -print> but some
post-processing happens on the output, described below.

This returns a list of strings I<without any prefix>.  Thus
if the directory structure was:

 /tmp/a
 /tmp/b
 /tmp/c/d

then the returned list from C<$g-E<gt>find> F</tmp> would be
4 elements:

 a
 b
 c
 c/d

If F<directory> is not a directory, then this command returns
an error.

The returned list is sorted.

=item $g->find0 ($directory, $files);

This command lists out all files and directories, recursively,
starting at F<directory>, placing the resulting list in the
external file called F<files>.

This command works the same way as C<$g-E<gt>find> with the
following exceptions:

=over 4

=item *

The resulting list is written to an external file.

=item *

Items (filenames) in the result are separated
by C<\0> characters.  See L<find(1)> option I<-print0>.

=item *

The result list is not sorted.

=back

=item @dirents = $g->find_inode ($device, $inode);

Searches all the entries associated with the given inode.

For each entry, a C<tsk_dirent> structure is returned.
See C<filesystem_walk> for more information about C<tsk_dirent> structures.

This function depends on the feature C<libtsk>.  See also
C<$g-E<gt>feature-available>.

=item $device = $g->findfs_label ($label);

This command searches the filesystems and returns the one
which has the given label.  An error is returned if no such
filesystem can be found.

To find the label of a filesystem, use C<$g-E<gt>vfs_label>.

=item $device = $g->findfs_partlabel ($label);

This command searches the partitions and returns the one
which has the given label.  An error is returned if no such
partition can be found.

To find the label of a partition, use C<$g-E<gt>blkid> (C<PART_ENTRY_NAME>).

=item $device = $g->findfs_partuuid ($uuid);

This command searches the partitions and returns the one
which has the given partition UUID.  An error is returned if no such
partition can be found.

To find the UUID of a partition, use C<$g-E<gt>blkid> (C<PART_ENTRY_UUID>).

=item $device = $g->findfs_uuid ($uuid);

This command searches the filesystems and returns the one
which has the given UUID.  An error is returned if no such
filesystem can be found.

To find the UUID of a filesystem, use C<$g-E<gt>vfs_uuid>.

=item $status = $g->fsck ($fstype, $device);

This runs the filesystem checker (fsck) on C<device> which
should have filesystem type C<fstype>.

The returned integer is the status.  See L<fsck(8)> for the
list of status codes from C<fsck>.

Notes:

=over 4

=item *

Multiple status codes can be summed together.

=item *

A non-zero return code can mean "success", for example if
errors have been corrected on the filesystem.

=item *

Checking or repairing NTFS volumes is not supported
(by linux-ntfs).

=back

This command is entirely equivalent to running C<fsck -a -t fstype device>.

=item $g->fstrim ($mountpoint [, offset => $offset] [, length => $length] [, minimumfreeextent => $minimumfreeextent]);

Trim the free space in the filesystem mounted on C<mountpoint>.
The filesystem must be mounted read-write.

The filesystem contents are not affected, but any free space
in the filesystem is "trimmed", that is, given back to the host
device, thus making disk images more sparse, allowing unused space
in qcow2 files to be reused, etc.

This operation requires support in libguestfs, the mounted
filesystem, the host filesystem, qemu and the host kernel.
If this support isn't present it may give an error or even
appear to run but do nothing.

In the case where the kernel vfs driver does not support
trimming, this call will fail with errno set to C<ENOTSUP>.
Currently this happens when trying to trim FAT filesystems.

See also C<$g-E<gt>zero_free_space>.  That is a slightly
different operation that turns free space in the filesystem
into zeroes.  It is valid to call C<$g-E<gt>fstrim> either
instead of, or after calling C<$g-E<gt>zero_free_space>.

This function depends on the feature C<fstrim>.  See also
C<$g-E<gt>feature-available>.

=item $append = $g->get_append ();

Return the additional kernel options which are added to the
libguestfs appliance kernel command line.

If C<NULL> then no options are added.

=item $backend = $g->get_attach_method ();

Return the current backend.

See C<$g-E<gt>set_backend> and L<guestfs(3)/BACKEND>.

I<This function is deprecated.>
In new code, use the L</get_backend> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $autosync = $g->get_autosync ();

Get the autosync flag.

=item $backend = $g->get_backend ();

Return the current backend.

This handle property was previously called the "attach method".

See C<$g-E<gt>set_backend> and L<guestfs(3)/BACKEND>.

=item $val = $g->get_backend_setting ($name);

Find a backend setting string which is either C<"name"> or
begins with C<"name=">.  If C<"name">, this returns the
string C<"1">.  If C<"name=">, this returns the part
after the equals sign (which may be an empty string).

If no such setting is found, this function throws an error.
The errno (see C<$g-E<gt>last_errno>) will be C<ESRCH> in this
case.

See L<guestfs(3)/BACKEND>, L<guestfs(3)/BACKEND SETTINGS>.

=item @settings = $g->get_backend_settings ();

Return the current backend settings.

This call returns all backend settings strings.  If you want to
find a single backend setting, see C<$g-E<gt>get_backend_setting>.

See L<guestfs(3)/BACKEND>, L<guestfs(3)/BACKEND SETTINGS>.

=item $cachedir = $g->get_cachedir ();

Get the directory used by the handle to store the appliance cache.

=item $direct = $g->get_direct ();

Return the direct appliance mode flag.

I<This function is deprecated.>
In new code, use the L</internal_get_console_socket> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $attrs = $g->get_e2attrs ($file);

This returns the file attributes associated with F<file>.

The attributes are a set of bits associated with each
inode which affect the behaviour of the file.  The attributes
are returned as a string of letters (described below).  The
string may be empty, indicating that no file attributes are
set for this file.

These attributes are only present when the file is located on
an ext2/3/4 filesystem.  Using this call on other filesystem
types will result in an error.

The characters (file attributes) in the returned string are
currently:

=over 4

=item 'A'

When the file is accessed, its atime is not modified.

=item 'a'

The file is append-only.

=item 'c'

The file is compressed on-disk.

=item 'D'

(Directories only.)  Changes to this directory are written
synchronously to disk.

=item 'd'

The file is not a candidate for backup (see L<dump(8)>).

=item 'E'

The file has compression errors.

=item 'e'

The file is using extents.

=item 'h'

The file is storing its blocks in units of the filesystem blocksize
instead of sectors.

=item 'I'

(Directories only.)  The directory is using hashed trees.

=item 'i'

The file is immutable.  It cannot be modified, deleted or renamed.
No link can be created to this file.

=item 'j'

The file is data-journaled.

=item 's'

When the file is deleted, all its blocks will be zeroed.

=item 'S'

Changes to this file are written synchronously to disk.

=item 'T'

(Directories only.)  This is a hint to the block allocator
that subdirectories contained in this directory should be
spread across blocks.  If not present, the block allocator
will try to group subdirectories together.

=item 't'

For a file, this disables tail-merging.
(Not used by upstream implementations of ext2.)

=item 'u'

When the file is deleted, its blocks will be saved, allowing
the file to be undeleted.

=item 'X'

The raw contents of the compressed file may be accessed.

=item 'Z'

The compressed file is dirty.

=back

More file attributes may be added to this list later.  Not all
file attributes may be set for all kinds of files.  For
detailed information, consult the L<chattr(1)> man page.

See also C<$g-E<gt>set_e2attrs>.

Don't confuse these attributes with extended attributes
(see C<$g-E<gt>getxattr>).

=item $generation = $g->get_e2generation ($file);

This returns the ext2 file generation of a file.  The generation
(which used to be called the "version") is a number associated
with an inode.  This is most commonly used by NFS servers.

The generation is only present when the file is located on
an ext2/3/4 filesystem.  Using this call on other filesystem
types will result in an error.

See C<$g-E<gt>set_e2generation>.

=item $label = $g->get_e2label ($device);

This returns the ext2/3/4 filesystem label of the filesystem on
C<device>.

I<This function is deprecated.>
In new code, use the L</vfs_label> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $uuid = $g->get_e2uuid ($device);

This returns the ext2/3/4 filesystem UUID of the filesystem on
C<device>.

I<This function is deprecated.>
In new code, use the L</vfs_uuid> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $hv = $g->get_hv ();

Return the current hypervisor binary.

This is always non-NULL.  If it wasn't set already, then this will
return the default qemu binary name.

=item $identifier = $g->get_identifier ();

Get the handle identifier.  See C<$g-E<gt>set_identifier>.

=item $challenge = $g->get_libvirt_requested_credential_challenge ($index);

Get the challenge (provided by libvirt) for the C<index>'th
requested credential.  If libvirt did not provide a challenge,
this returns the empty string C<"">.

See L<guestfs(3)/LIBVIRT AUTHENTICATION> for documentation and example code.

=item $defresult = $g->get_libvirt_requested_credential_defresult ($index);

Get the default result (provided by libvirt) for the C<index>'th
requested credential.  If libvirt did not provide a default result,
this returns the empty string C<"">.

See L<guestfs(3)/LIBVIRT AUTHENTICATION> for documentation and example code.

=item $prompt = $g->get_libvirt_requested_credential_prompt ($index);

Get the prompt (provided by libvirt) for the C<index>'th
requested credential.  If libvirt did not provide a prompt,
this returns the empty string C<"">.

See L<guestfs(3)/LIBVIRT AUTHENTICATION> for documentation and example code.

=item @creds = $g->get_libvirt_requested_credentials ();

This should only be called during the event callback
for events of type C<GUESTFS_EVENT_LIBVIRT_AUTH>.

Return the list of credentials requested by libvirt.  Possible
values are a subset of the strings provided when you called
C<$g-E<gt>set_libvirt_supported_credentials>.

See L<guestfs(3)/LIBVIRT AUTHENTICATION> for documentation and example code.

=item $memsize = $g->get_memsize ();

This gets the memory size in megabytes allocated to the
hypervisor.

If C<$g-E<gt>set_memsize> was not called
on this handle, and if C<LIBGUESTFS_MEMSIZE> was not set,
then this returns the compiled-in default value for memsize.

For more information on the architecture of libguestfs,
see L<guestfs(3)>.

=item $network = $g->get_network ();

This returns the enable network flag.

=item $path = $g->get_path ();

Return the current search path.

This is always non-NULL.  If it wasn't set already, then this will
return the default path.

=item $pgroup = $g->get_pgroup ();

This returns the process group flag.

=item $pid = $g->get_pid ();

Return the process ID of the hypervisor.  If there is no
hypervisor running, then this will return an error.

This is an internal call used for debugging and testing.

=item $program = $g->get_program ();

Get the program name.  See C<$g-E<gt>set_program>.

=item $hv = $g->get_qemu ();

Return the current hypervisor binary (usually qemu).

This is always non-NULL.  If it wasn't set already, then this will
return the default qemu binary name.

I<This function is deprecated.>
In new code, use the L</get_hv> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $recoveryproc = $g->get_recovery_proc ();

Return the recovery process enabled flag.

=item $selinux = $g->get_selinux ();

This returns the current setting of the selinux flag which
is passed to the appliance at boot time.  See C<$g-E<gt>set_selinux>.

For more information on the architecture of libguestfs,
see L<guestfs(3)>.

I<This function is deprecated.>
In new code, use the L</selinux_relabel> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $smp = $g->get_smp ();

This returns the number of virtual CPUs assigned to the appliance.

=item $sockdir = $g->get_sockdir ();

Get the directory used by the handle to store temporary socket and PID
files.

This is different from C<$g-E<gt>get_tmpdir>, as we need shorter
paths for sockets (due to the limited buffers of filenames for UNIX
sockets), and C<$g-E<gt>get_tmpdir> may be too long for them.
Furthermore, sockets and PID files must be accessible to such background
services started by libguestfs that may not have permission to access
the temporary directory returned by C<$g-E<gt>get_tmpdir>.

The environment variable C<XDG_RUNTIME_DIR> controls the default
value: If C<XDG_RUNTIME_DIR> is set, then that is the default.
Else F</tmp> is the default.

=item $state = $g->get_state ();

This returns the current state as an opaque integer.  This is
only useful for printing debug and internal error messages.

For more information on states, see L<guestfs(3)>.

=item $tmpdir = $g->get_tmpdir ();

Get the directory used by the handle to store temporary files.

=item $trace = $g->get_trace ();

Return the command trace flag.

=item $mask = $g->get_umask ();

Return the current umask.  By default the umask is C<022>
unless it has been set by calling C<$g-E<gt>umask>.

=item $verbose = $g->get_verbose ();

This returns the verbose messages flag.

=item $context = $g->getcon ();

This gets the SELinux security context of the daemon.

See the documentation about SELINUX in L<guestfs(3)>,
and C<$g-E<gt>setcon>

This function depends on the feature C<selinux>.  See also
C<$g-E<gt>feature-available>.

I<This function is deprecated.>
In new code, use the L</selinux_relabel> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $xattr = $g->getxattr ($path, $name);

Get a single extended attribute from file C<path> named C<name>.
This call follows symlinks.  If you want to lookup an extended
attribute for the symlink itself, use C<$g-E<gt>lgetxattr>.

Normally it is better to get all extended attributes from a file
in one go by calling C<$g-E<gt>getxattrs>.  However some Linux
filesystem implementations are buggy and do not provide a way to
list out attributes.  For these filesystems (notably ntfs-3g)
you have to know the names of the extended attributes you want
in advance and call this function.

Extended attribute values are blobs of binary data.  If there
is no extended attribute named C<name>, this returns an error.

See also: C<$g-E<gt>getxattrs>, C<$g-E<gt>lgetxattr>, L<attr(5)>.

This function depends on the feature C<linuxxattrs>.  See also
C<$g-E<gt>feature-available>.

=item @xattrs = $g->getxattrs ($path);

This call lists the extended attributes of the file or directory
C<path>.

At the system call level, this is a combination of the
L<listxattr(2)> and L<getxattr(2)> calls.

See also: C<$g-E<gt>lgetxattrs>, L<attr(5)>.

This function depends on the feature C<linuxxattrs>.  See also
C<$g-E<gt>feature-available>.

=item @paths = $g->glob_expand ($pattern [, directoryslash => $directoryslash]);

This command searches for all the pathnames matching
C<pattern> according to the wildcard expansion rules
used by the shell.

If no paths match, then this returns an empty list
(note: not an error).

It is just a wrapper around the C L<glob(3)> function
with flags C<GLOB_MARK|GLOB_BRACE>.
See that manual page for more details.

C<directoryslash> controls whether use the C<GLOB_MARK> flag for
L<glob(3)>, and it defaults to true.  It can be explicitly set as
off to return no trailing slashes in filenames of directories.

Notice that there is no equivalent command for expanding a device
name (eg. F</dev/sd*>).  Use C<$g-E<gt>list_devices>,
C<$g-E<gt>list_partitions> etc functions instead.

=item @paths = $g->glob_expand_opts ($pattern [, directoryslash => $directoryslash]);

This is an alias of L</glob_expand>.

=cut

sub glob_expand_opts {
  &glob_expand (@_)
}

=pod

=item @lines = $g->grep ($regex, $path [, extended => $extended] [, fixed => $fixed] [, insensitive => $insensitive] [, compressed => $compressed]);

This calls the external L<grep(1)> program and returns the
matching lines.

The optional flags are:

=over 4

=item C<extended>

Use extended regular expressions.
This is the same as using the I<-E> flag.

=item C<fixed>

Match fixed (don't use regular expressions).
This is the same as using the I<-F> flag.

=item C<insensitive>

Match case-insensitive.  This is the same as using the I<-i> flag.

=item C<compressed>

Use L<zgrep(1)> instead of L<grep(1)>.  This allows the input to be
compress- or gzip-compressed.

=back

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

=item @lines = $g->grep_opts ($regex, $path [, extended => $extended] [, fixed => $fixed] [, insensitive => $insensitive] [, compressed => $compressed]);

This is an alias of L</grep>.

=cut

sub grep_opts {
  &grep (@_)
}

=pod

=item @lines = $g->grepi ($regex, $path);

This calls the external C<grep -i> program and returns the
matching lines.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

I<This function is deprecated.>
In new code, use the L</grep> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->grub_install ($root, $device);

This command installs GRUB 1 (the Grand Unified Bootloader) on
C<device>, with the root directory being C<root>.

Notes:

=over 4

=item *

There is currently no way in the API to install grub2, which
is used by most modern Linux guests.  It is possible to run
the grub2 command from the guest, although see the
caveats in L<guestfs(3)/RUNNING COMMANDS>.

=item *

This uses L<grub-install(8)> from the host.  Unfortunately grub is
not always compatible with itself, so this only works in rather
narrow circumstances.  Careful testing with each guest version
is advisable.

=item *

If grub-install reports the error
"No suitable drive was found in the generated device map."
it may be that you need to create a F</boot/grub/device.map>
file first that contains the mapping between grub device names
and Linux device names.  It is usually sufficient to create
a file containing:

 (hd0) /dev/vda

replacing F</dev/vda> with the name of the installation device.

=back

This function depends on the feature C<grub>.  See also
C<$g-E<gt>feature-available>.

=item @lines = $g->head ($path);

This command returns up to the first 10 lines of a file as
a list of strings.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

=item @lines = $g->head_n ($nrlines, $path);

If the parameter C<nrlines> is a positive number, this returns the first
C<nrlines> lines of the file C<path>.

If the parameter C<nrlines> is a negative number, this returns lines
from the file C<path>, excluding the last C<nrlines> lines.

If the parameter C<nrlines> is zero, this returns an empty list.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

=item $dump = $g->hexdump ($path);

This runs C<hexdump -C> on the given C<path>.  The result is
the human-readable, canonical hex dump of the file.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

=item $g->hivex_close ();

Close the current hivex handle.

This is a wrapper around the L<hivex(3)> call of the same name.

This function depends on the feature C<hivex>.  See also
C<$g-E<gt>feature-available>.

=item $g->hivex_commit ($filename);

Commit (write) changes to the hive.

If the optional F<filename> parameter is null, then the changes
are written back to the same hive that was opened.  If this is
not null then they are written to the alternate filename given
and the original hive is left untouched.

This is a wrapper around the L<hivex(3)> call of the same name.

This function depends on the feature C<hivex>.  See also
C<$g-E<gt>feature-available>.

=item $nodeh = $g->hivex_node_add_child ($parent, $name);

Add a child node to C<parent> named C<name>.

This is a wrapper around the L<hivex(3)> call of the same name.

This function depends on the feature C<hivex>.  See also
C<$g-E<gt>feature-available>.

=item @nodehs = $g->hivex_node_children ($nodeh);

Return the list of nodes which are subkeys of C<nodeh>.

This is a wrapper around the L<hivex(3)> call of the same name.

This function depends on the feature C<hivex>.  See also
C<$g-E<gt>feature-available>.

=item $g->hivex_node_delete_child ($nodeh);

Delete C<nodeh>, recursively if necessary.

This is a wrapper around the L<hivex(3)> call of the same name.

This function depends on the feature C<hivex>.  See also
C<$g-E<gt>feature-available>.

=item $child = $g->hivex_node_get_child ($nodeh, $name);

Return the child of C<nodeh> with the name C<name>, if it exists.
This can return C<0> meaning the name was not found.

This is a wrapper around the L<hivex(3)> call of the same name.

This function depends on the feature C<hivex>.  See also
C<$g-E<gt>feature-available>.

=item $valueh = $g->hivex_node_get_value ($nodeh, $key);

Return the value attached to C<nodeh> which has the
name C<key>, if it exists.  This can return C<0> meaning
the key was not found.

This is a wrapper around the L<hivex(3)> call of the same name.

This function depends on the feature C<hivex>.  See also
C<$g-E<gt>feature-available>.

=item $name = $g->hivex_node_name ($nodeh);

Return the name of C<nodeh>.

This is a wrapper around the L<hivex(3)> call of the same name.

This function depends on the feature C<hivex>.  See also
C<$g-E<gt>feature-available>.

=item $parent = $g->hivex_node_parent ($nodeh);

Return the parent node of C<nodeh>.

This is a wrapper around the L<hivex(3)> call of the same name.

This function depends on the feature C<hivex>.  See also
C<$g-E<gt>feature-available>.

=item $g->hivex_node_set_value ($nodeh, $key, $t, $val);

Set or replace a single value under the node C<nodeh>.  The
C<key> is the name, C<t> is the type, and C<val> is the data.

This is a wrapper around the L<hivex(3)> call of the same name.

This function depends on the feature C<hivex>.  See also
C<$g-E<gt>feature-available>.

=item @valuehs = $g->hivex_node_values ($nodeh);

Return the array of (key, datatype, data) tuples attached to C<nodeh>.

This is a wrapper around the L<hivex(3)> call of the same name.

This function depends on the feature C<hivex>.  See also
C<$g-E<gt>feature-available>.

=item $g->hivex_open ($filename [, verbose => $verbose] [, debug => $debug] [, write => $write] [, unsafe => $unsafe]);

Open the Windows Registry hive file named F<filename>.
If there was any previous hivex handle associated with this
guestfs session, then it is closed.

This is a wrapper around the L<hivex(3)> call of the same name.

This function depends on the feature C<hivex>.  See also
C<$g-E<gt>feature-available>.

=item $nodeh = $g->hivex_root ();

Return the root node of the hive.

This is a wrapper around the L<hivex(3)> call of the same name.

This function depends on the feature C<hivex>.  See also
C<$g-E<gt>feature-available>.

=item $key = $g->hivex_value_key ($valueh);

Return the key (name) field of a (key, datatype, data) tuple.

This is a wrapper around the L<hivex(3)> call of the same name.

This function depends on the feature C<hivex>.  See also
C<$g-E<gt>feature-available>.

=item $databuf = $g->hivex_value_string ($valueh);

This calls C<$g-E<gt>hivex_value_value> (which returns the
data field from a hivex value tuple).  It then assumes that
the field is a UTF-16LE string and converts the result to
UTF-8 (or if this is not possible, it returns an error).

This is useful for reading strings out of the Windows registry.
However it is not foolproof because the registry is not
strongly-typed and fields can contain arbitrary or unexpected
data.

This function depends on the feature C<hivex>.  See also
C<$g-E<gt>feature-available>.

=item $datatype = $g->hivex_value_type ($valueh);

Return the data type field from a (key, datatype, data) tuple.

This is a wrapper around the L<hivex(3)> call of the same name.

This function depends on the feature C<hivex>.  See also
C<$g-E<gt>feature-available>.

=item $databuf = $g->hivex_value_utf8 ($valueh);

This calls C<$g-E<gt>hivex_value_value> (which returns the
data field from a hivex value tuple).  It then assumes that
the field is a UTF-16LE string and converts the result to
UTF-8 (or if this is not possible, it returns an error).

This is useful for reading strings out of the Windows registry.
However it is not foolproof because the registry is not
strongly-typed and fields can contain arbitrary or unexpected
data.

This function depends on the feature C<hivex>.  See also
C<$g-E<gt>feature-available>.

I<This function is deprecated.>
In new code, use the L</hivex_value_string> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $databuf = $g->hivex_value_value ($valueh);

Return the data field of a (key, datatype, data) tuple.

This is a wrapper around the L<hivex(3)> call of the same name.

See also: C<$g-E<gt>hivex_value_utf8>.

This function depends on the feature C<hivex>.  See also
C<$g-E<gt>feature-available>.

=item $content = $g->initrd_cat ($initrdpath, $filename);

This command unpacks the file F<filename> from the initrd file
called F<initrdpath>.  The filename must be given I<without> the
initial F</> character.

For example, in guestfish you could use the following command
to examine the boot script (usually called F</init>)
contained in a Linux initrd or initramfs image:

 initrd-cat /boot/initrd-<version>.img init

See also C<$g-E<gt>initrd_list>.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

=item @filenames = $g->initrd_list ($path);

This command lists out files contained in an initrd.

The files are listed without any initial F</> character.  The
files are listed in the order they appear (not necessarily
alphabetical).  Directory names are listed as separate items.

Old Linux kernels (2.4 and earlier) used a compressed ext2
filesystem as initrd.  We I<only> support the newer initramfs
format (compressed cpio files).

=item $wd = $g->inotify_add_watch ($path, $mask);

Watch C<path> for the events listed in C<mask>.

Note that if C<path> is a directory then events within that
directory are watched, but this does I<not> happen recursively
(in subdirectories).

Note for non-C or non-Linux callers: the inotify events are
defined by the Linux kernel ABI and are listed in
F</usr/include/sys/inotify.h>.

This function depends on the feature C<inotify>.  See also
C<$g-E<gt>feature-available>.

=item $g->inotify_close ();

This closes the inotify handle which was previously
opened by inotify_init.  It removes all watches, throws
away any pending events, and deallocates all resources.

This function depends on the feature C<inotify>.  See also
C<$g-E<gt>feature-available>.

=item @paths = $g->inotify_files ();

This function is a helpful wrapper around C<$g-E<gt>inotify_read>
which just returns a list of pathnames of objects that were
touched.  The returned pathnames are sorted and deduplicated.

This function depends on the feature C<inotify>.  See also
C<$g-E<gt>feature-available>.

=item $g->inotify_init ($maxevents);

This command creates a new inotify handle.
The inotify subsystem can be used to notify events which happen to
objects in the guest filesystem.

C<maxevents> is the maximum number of events which will be
queued up between calls to C<$g-E<gt>inotify_read> or
C<$g-E<gt>inotify_files>.
If this is passed as C<0>, then the kernel (or previously set)
default is used.  For Linux 2.6.29 the default was 16384 events.
Beyond this limit, the kernel throws away events, but records
the fact that it threw them away by setting a flag
C<IN_Q_OVERFLOW> in the returned structure list (see
C<$g-E<gt>inotify_read>).

Before any events are generated, you have to add some
watches to the internal watch list.  See: C<$g-E<gt>inotify_add_watch> and
C<$g-E<gt>inotify_rm_watch>.

Queued up events should be read periodically by calling
C<$g-E<gt>inotify_read>
(or C<$g-E<gt>inotify_files> which is just a helpful
wrapper around C<$g-E<gt>inotify_read>).  If you don't
read the events out often enough then you risk the internal
queue overflowing.

The handle should be closed after use by calling
C<$g-E<gt>inotify_close>.  This also removes any
watches automatically.

See also L<inotify(7)> for an overview of the inotify interface
as exposed by the Linux kernel, which is roughly what we expose
via libguestfs.  Note that there is one global inotify handle
per libguestfs instance.

This function depends on the feature C<inotify>.  See also
C<$g-E<gt>feature-available>.

=item @events = $g->inotify_read ();

Return the complete queue of events that have happened
since the previous read call.

If no events have happened, this returns an empty list.

I<Note>: In order to make sure that all events have been
read, you must call this function repeatedly until it
returns an empty list.  The reason is that the call will
read events up to the maximum appliance-to-host message
size and leave remaining events in the queue.

This function depends on the feature C<inotify>.  See also
C<$g-E<gt>feature-available>.

=item $g->inotify_rm_watch ($wd);

Remove a previously defined inotify watch.
See C<$g-E<gt>inotify_add_watch>.

This function depends on the feature C<inotify>.  See also
C<$g-E<gt>feature-available>.

=item $arch = $g->inspect_get_arch ($root);

This returns the architecture of the inspected operating system.
The possible return values are listed under
C<$g-E<gt>file_architecture>.

If the architecture could not be determined, then the
string C<unknown> is returned.

Please read L<guestfs(3)/INSPECTION> for more details.

=item $buildid = $g->inspect_get_build_id ($root);

This returns the build ID of the system, or the string
C<"unknown"> if the system does not have a build ID.

For Windows, this gets the build number.  Although it is
returned as a string, it is (so far) always a number.  See
L<https://en.wikipedia.org/wiki/List_of_Microsoft_Windows_versions>
for some possible values.

For Linux, this returns the C<BUILD_ID> string from
F</etc/os-release>, although this is not often used.

Please read L<guestfs(3)/INSPECTION> for more details.

=item $distro = $g->inspect_get_distro ($root);

This returns the distro (distribution) of the inspected operating
system.

Currently defined distros are:

=over 4

=item "alpinelinux"

Alpine Linux.

=item "altlinux"

ALT Linux.

=item "archlinux"

Arch Linux.

=item "buildroot"

Buildroot-derived distro, but not one we specifically recognize.

=item "centos"

CentOS.

=item "circle"

Circle Linux.

=item "cirros"

Cirros.

=item "coreos"

CoreOS.

=item "debian"

Debian.

=item "fedora"

Fedora.

=item "freebsd"

FreeBSD.

=item "freedos"

FreeDOS.

=item "frugalware"

Frugalware.

=item "gentoo"

Gentoo.

=item "kalilinux"

Kali Linux.

=item "kylin"

Kylin.

=item "linuxmint"

Linux Mint.

=item "mageia"

Mageia.

=item "mandriva"

Mandriva.

=item "meego"

MeeGo.

=item "msdos"

Microsoft DOS.

=item "neokylin"

NeoKylin.

=item "netbsd"

NetBSD.

=item "openbsd"

OpenBSD.

=item "openeuler"

openEuler.

=item "openmandriva"

OpenMandriva Lx.

=item "opensuse"

OpenSUSE.

=item "oraclelinux"

Oracle Linux.

=item "pardus"

Pardus.

=item "pldlinux"

PLD Linux.

=item "redhat-based"

Some Red Hat-derived distro.

=item "rhel"

Red Hat Enterprise Linux.

=item "rocky"

Rocky Linux.

=item "scientificlinux"

Scientific Linux.

=item "slackware"

Slackware.

=item "sles"

SuSE Linux Enterprise Server or Desktop.

=item "suse-based"

Some openSuSE-derived distro.

=item "ttylinux"

ttylinux.

=item "ubuntu"

Ubuntu.

=item "unknown"

The distro could not be determined.

=item "voidlinux"

Void Linux.

=item "windows"

Windows does not have distributions.  This string is
returned if the OS type is Windows.

=back

Future versions of libguestfs may return other strings here.
The caller should be prepared to handle any string.

Please read L<guestfs(3)/INSPECTION> for more details.

=item %drives = $g->inspect_get_drive_mappings ($root);

This call is useful for Windows which uses a primitive system
of assigning drive letters (like F<C:\>) to partitions.
This inspection API examines the Windows Registry to find out
how disks/partitions are mapped to drive letters, and returns
a hash table as in the example below:

 C      =>     /dev/vda2
 E      =>     /dev/vdb1
 F      =>     /dev/vdc1

Note that keys are drive letters.  For Windows, the key is
case insensitive and just contains the drive letter, without
the customary colon separator character.

In future we may support other operating systems that also used drive
letters, but the keys for those might not be case insensitive
and might be longer than 1 character.  For example in OS-9,
hard drives were named C<h0>, C<h1> etc.

For Windows guests, currently only hard drive mappings are
returned.  Removable disks (eg. DVD-ROMs) are ignored.

For guests that do not use drive mappings, or if the drive mappings
could not be determined, this returns an empty hash table.

Please read L<guestfs(3)/INSPECTION> for more details.
See also C<$g-E<gt>inspect_get_mountpoints>,
C<$g-E<gt>inspect_get_filesystems>.

=item @filesystems = $g->inspect_get_filesystems ($root);

This returns a list of all the filesystems that we think
are associated with this operating system.  This includes
the root filesystem, other ordinary filesystems, and
non-mounted devices like swap partitions.

In the case of a multi-boot virtual machine, it is possible
for a filesystem to be shared between operating systems.

Please read L<guestfs(3)/INSPECTION> for more details.
See also C<$g-E<gt>inspect_get_mountpoints>.

=item $format = $g->inspect_get_format ($root);

Before libguestfs 1.38, there was some unreliable support for detecting
installer CDs.  This API would return:

=over 4

=item C<installed>

This is an installed operating system.

=item C<installer>

The disk image being inspected is not an installed operating system,
but a I<bootable> install disk, live CD, or similar.

=item C<unknown>

The format of this disk image is not known.

=back

In libguestfs E<ge> 1.38, this only returns C<installed>.
Use libosinfo directly to detect installer CDs.

Please read L<guestfs(3)/INSPECTION> for more details.

I<This function is deprecated.>
There is no replacement.  Consult the API documentation in
L<guestfs(3)> for further information.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $hostname = $g->inspect_get_hostname ($root);

This function returns the hostname of the operating system
as found by inspection of the guest’s configuration files.

If the hostname could not be determined, then the
string C<unknown> is returned.

Please read L<guestfs(3)/INSPECTION> for more details.

=item $icon = $g->inspect_get_icon ($root [, favicon => $favicon] [, highquality => $highquality]);

This function returns an icon corresponding to the inspected
operating system.  The icon is returned as a buffer containing a
PNG image (re-encoded to PNG if necessary).

If it was not possible to get an icon this function returns a
zero-length (non-NULL) buffer.  I<Callers must check for this case>.

Libguestfs will start by looking for a file called
F</etc/favicon.png> or F<C:\etc\favicon.png>
and if it has the correct format, the contents of this file will
be returned.  You can disable favicons by passing the
optional C<favicon> boolean as false (default is true).

If finding the favicon fails, then we look in other places in the
guest for a suitable icon.

If the optional C<highquality> boolean is true then
only high quality icons are returned, which means only icons of
high resolution with an alpha channel.  The default (false) is
to return any icon we can, even if it is of substandard quality.

Notes:

=over 4

=item *

Unlike most other inspection API calls, the guest’s disks must be
mounted up before you call this, since it needs to read information
from the guest filesystem during the call.

=item *

B<Security:> The icon data comes from the untrusted guest,
and should be treated with caution.  PNG files have been
known to contain exploits.  Ensure that libpng (or other relevant
libraries) are fully up to date before trying to process or
display the icon.

=item *

The PNG image returned can be any size.  It might not be square.
Libguestfs tries to return the largest, highest quality
icon available.  The application must scale the icon to the
required size.

=item *

Extracting icons from Windows guests requires the external
L<wrestool(1)> program from the C<icoutils> package, and
several programs (L<bmptopnm(1)>, L<pnmtopng(1)>, L<pamcut(1)>)
from the C<netpbm> package.  These must be installed separately.

=item *

Operating system icons are usually trademarks.  Seek legal
advice before using trademarks in applications.

=back

=item $major = $g->inspect_get_major_version ($root);

This returns the major version number of the inspected operating
system.

Windows uses a consistent versioning scheme which is I<not>
reflected in the popular public names used by the operating system.
Notably the operating system known as "Windows 7" is really
version 6.1 (ie. major = 6, minor = 1).  You can find out the
real versions corresponding to releases of Windows by consulting
Wikipedia or MSDN.

If the version could not be determined, then C<0> is returned.

Please read L<guestfs(3)/INSPECTION> for more details.

=item $minor = $g->inspect_get_minor_version ($root);

This returns the minor version number of the inspected operating
system.

If the version could not be determined, then C<0> is returned.

Please read L<guestfs(3)/INSPECTION> for more details.
See also C<$g-E<gt>inspect_get_major_version>.

=item %mountpoints = $g->inspect_get_mountpoints ($root);

This returns a hash of where we think the filesystems
associated with this operating system should be mounted.
Callers should note that this is at best an educated guess
made by reading configuration files such as F</etc/fstab>.
I<In particular note> that this may return filesystems
which are non-existent or not mountable and callers should
be prepared to handle or ignore failures if they try to
mount them.

Each element in the returned hashtable has a key which
is the path of the mountpoint (eg. F</boot>) and a value
which is the filesystem that would be mounted there
(eg. F</dev/sda1>).

Non-mounted devices such as swap devices are I<not>
returned in this list.

For operating systems like Windows which still use drive
letters, this call will only return an entry for the first
drive "mounted on" F</>.  For information about the
mapping of drive letters to partitions, see
C<$g-E<gt>inspect_get_drive_mappings>.

Please read L<guestfs(3)/INSPECTION> for more details.
See also C<$g-E<gt>inspect_get_filesystems>.

=item $id = $g->inspect_get_osinfo ($root);

This function returns a possible short ID for libosinfo corresponding
to the guest.

I<Note:> The returned ID is only a guess by libguestfs, and nothing
ensures that it actually exists in osinfo-db.

If no ID could not be determined, then the string C<unknown> is
returned.

=item $packageformat = $g->inspect_get_package_format ($root);

This function and C<$g-E<gt>inspect_get_package_management> return
the package format and package management tool used by the
inspected operating system.  For example for Fedora these
functions would return C<rpm> (package format), and
C<yum> or C<dnf> (package management).

This returns the string C<unknown> if we could not determine the
package format I<or> if the operating system does not have
a real packaging system (eg. Windows).

Possible strings include:
C<rpm>, C<deb>, C<ebuild>, C<pisi>, C<pacman>, C<pkgsrc>, C<apk>,
C<xbps>.
Future versions of libguestfs may return other strings.

Please read L<guestfs(3)/INSPECTION> for more details.

=item $packagemanagement = $g->inspect_get_package_management ($root);

C<$g-E<gt>inspect_get_package_format> and this function return
the package format and package management tool used by the
inspected operating system.  For example for Fedora these
functions would return C<rpm> (package format), and
C<yum> or C<dnf> (package management).

This returns the string C<unknown> if we could not determine the
package management tool I<or> if the operating system does not have
a real packaging system (eg. Windows).

Possible strings include: C<yum>, C<dnf>, C<up2date>,
C<apt> (for all Debian derivatives),
C<portage>, C<pisi>, C<pacman>, C<urpmi>, C<zypper>, C<apk>, C<xbps>.
Future versions of libguestfs may return other strings.

Please read L<guestfs(3)/INSPECTION> for more details.

=item $product = $g->inspect_get_product_name ($root);

This returns the product name of the inspected operating
system.  The product name is generally some freeform string
which can be displayed to the user, but should not be
parsed by programs.

If the product name could not be determined, then the
string C<unknown> is returned.

Please read L<guestfs(3)/INSPECTION> for more details.

=item $variant = $g->inspect_get_product_variant ($root);

This returns the product variant of the inspected operating
system.

For Windows guests, this returns the contents of the Registry key
C<HKLM\Software\Microsoft\Windows NT\CurrentVersion>
C<InstallationType> which is usually a string such as
C<Client> or C<Server> (other values are possible).  This
can be used to distinguish consumer and enterprise versions
of Windows that have the same version number (for example,
Windows 7 and Windows 2008 Server are both version 6.1,
but the former is C<Client> and the latter is C<Server>).

For enterprise Linux guests, in future we intend this to return
the product variant such as C<Desktop>, C<Server> and so on.  But
this is not implemented at present.

If the product variant could not be determined, then the
string C<unknown> is returned.

Please read L<guestfs(3)/INSPECTION> for more details.
See also C<$g-E<gt>inspect_get_product_name>,
C<$g-E<gt>inspect_get_major_version>.

=item @roots = $g->inspect_get_roots ();

This function is a convenient way to get the list of root
devices, as returned from a previous call to C<$g-E<gt>inspect_os>,
but without redoing the whole inspection process.

This returns an empty list if either no root devices were
found or the caller has not called C<$g-E<gt>inspect_os>.

Please read L<guestfs(3)/INSPECTION> for more details.

=item $name = $g->inspect_get_type ($root);

This returns the type of the inspected operating system.
Currently defined types are:

=over 4

=item "linux"

Any Linux-based operating system.

=item "windows"

Any Microsoft Windows operating system.

=item "freebsd"

FreeBSD.

=item "netbsd"

NetBSD.

=item "openbsd"

OpenBSD.

=item "hurd"

GNU/Hurd.

=item "dos"

MS-DOS, FreeDOS and others.

=item "minix"

MINIX.

=item "unknown"

The operating system type could not be determined.

=back

Future versions of libguestfs may return other strings here.
The caller should be prepared to handle any string.

Please read L<guestfs(3)/INSPECTION> for more details.

=item $controlset = $g->inspect_get_windows_current_control_set ($root);

This returns the Windows CurrentControlSet of the inspected guest.
The CurrentControlSet is a registry key name such as C<ControlSet001>.

This call assumes that the guest is Windows and that the
Registry could be examined by inspection.  If this is not
the case then an error is returned.

Please read L<guestfs(3)/INSPECTION> for more details.

=item $path = $g->inspect_get_windows_software_hive ($root);

This returns the path to the hive (binary Windows Registry file)
corresponding to HKLM\SOFTWARE.

This call assumes that the guest is Windows and that the guest
has a software hive file with the right name.  If this is not the
case then an error is returned.  This call does not check that the
hive is a valid Windows Registry hive.

You can use C<$g-E<gt>hivex_open> to read or write to the hive.

Please read L<guestfs(3)/INSPECTION> for more details.

=item $path = $g->inspect_get_windows_system_hive ($root);

This returns the path to the hive (binary Windows Registry file)
corresponding to HKLM\SYSTEM.

This call assumes that the guest is Windows and that the guest
has a system hive file with the right name.  If this is not the
case then an error is returned.  This call does not check that the
hive is a valid Windows Registry hive.

You can use C<$g-E<gt>hivex_open> to read or write to the hive.

Please read L<guestfs(3)/INSPECTION> for more details.

=item $systemroot = $g->inspect_get_windows_systemroot ($root);

This returns the Windows systemroot of the inspected guest.
The systemroot is a directory path such as F</WINDOWS>.

This call assumes that the guest is Windows and that the
systemroot could be determined by inspection.  If this is not
the case then an error is returned.

Please read L<guestfs(3)/INSPECTION> for more details.

=item $live = $g->inspect_is_live ($root);

This is deprecated and always returns C<false>.

Please read L<guestfs(3)/INSPECTION> for more details.

I<This function is deprecated.>
There is no replacement.  Consult the API documentation in
L<guestfs(3)> for further information.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $multipart = $g->inspect_is_multipart ($root);

This is deprecated and always returns C<false>.

Please read L<guestfs(3)/INSPECTION> for more details.

I<This function is deprecated.>
There is no replacement.  Consult the API documentation in
L<guestfs(3)> for further information.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $netinst = $g->inspect_is_netinst ($root);

This is deprecated and always returns C<false>.

Please read L<guestfs(3)/INSPECTION> for more details.

I<This function is deprecated.>
There is no replacement.  Consult the API documentation in
L<guestfs(3)> for further information.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item @applications = $g->inspect_list_applications ($root);

Return the list of applications installed in the operating system.

I<Note:> This call works differently from other parts of the
inspection API.  You have to call C<$g-E<gt>inspect_os>, then
C<$g-E<gt>inspect_get_mountpoints>, then mount up the disks,
before calling this.  Listing applications is a significantly
more difficult operation which requires access to the full
filesystem.  Also note that unlike the other
C<$g-E<gt>inspect_get_*> calls which are just returning
data cached in the libguestfs handle, this call actually reads
parts of the mounted filesystems during the call.

This returns an empty list if the inspection code was not able
to determine the list of applications.

The application structure contains the following fields:

=over 4

=item C<app_name>

The name of the application.  For Linux guests, this is the package
name.

=item C<app_display_name>

The display name of the application, sometimes localized to the
install language of the guest operating system.

If unavailable this is returned as an empty string C<"">.
Callers needing to display something can use C<app_name> instead.

=item C<app_epoch>

For package managers which use epochs, this contains the epoch of
the package (an integer).  If unavailable, this is returned as C<0>.

=item C<app_version>

The version string of the application or package.  If unavailable
this is returned as an empty string C<"">.

=item C<app_release>

The release string of the application or package, for package
managers that use this.  If unavailable this is returned as an
empty string C<"">.

=item C<app_install_path>

The installation path of the application (on operating systems
such as Windows which use installation paths).  This path is
in the format used by the guest operating system, it is not
a libguestfs path.

If unavailable this is returned as an empty string C<"">.

=item C<app_trans_path>

The install path translated into a libguestfs path.
If unavailable this is returned as an empty string C<"">.

=item C<app_publisher>

The name of the publisher of the application, for package
managers that use this.  If unavailable this is returned
as an empty string C<"">.

=item C<app_url>

The URL (eg. upstream URL) of the application.
If unavailable this is returned as an empty string C<"">.

=item C<app_source_package>

For packaging systems which support this, the name of the source
package.  If unavailable this is returned as an empty string C<"">.

=item C<app_summary>

A short (usually one line) description of the application or package.
If unavailable this is returned as an empty string C<"">.

=item C<app_description>

A longer description of the application or package.
If unavailable this is returned as an empty string C<"">.

=back

Please read L<guestfs(3)/INSPECTION> for more details.

I<This function is deprecated.>
In new code, use the L</inspect_list_applications2> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item @applications2 = $g->inspect_list_applications2 ($root);

Return the list of applications installed in the operating system.

I<Note:> This call works differently from other parts of the
inspection API.  You have to call C<$g-E<gt>inspect_os>, then
C<$g-E<gt>inspect_get_mountpoints>, then mount up the disks,
before calling this.  Listing applications is a significantly
more difficult operation which requires access to the full
filesystem.  Also note that unlike the other
C<$g-E<gt>inspect_get_*> calls which are just returning
data cached in the libguestfs handle, this call actually reads
parts of the mounted filesystems during the call.

This returns an empty list if the inspection code was not able
to determine the list of applications.

The application structure contains the following fields:

=over 4

=item C<app2_name>

The name of the application.  For Linux guests, this is the package
name.

=item C<app2_display_name>

The display name of the application, sometimes localized to the
install language of the guest operating system.

If unavailable this is returned as an empty string C<"">.
Callers needing to display something can use C<app2_name> instead.

=item C<app2_epoch>

For package managers which use epochs, this contains the epoch of
the package (an integer).  If unavailable, this is returned as C<0>.

=item C<app2_version>

The version string of the application or package.  If unavailable
this is returned as an empty string C<"">.

=item C<app2_release>

The release string of the application or package, for package
managers that use this.  If unavailable this is returned as an
empty string C<"">.

=item C<app2_arch>

The architecture string of the application or package, for package
managers that use this.  If unavailable this is returned as an empty
string C<"">.

=item C<app2_install_path>

The installation path of the application (on operating systems
such as Windows which use installation paths).  This path is
in the format used by the guest operating system, it is not
a libguestfs path.

If unavailable this is returned as an empty string C<"">.

=item C<app2_trans_path>

The install path translated into a libguestfs path.
If unavailable this is returned as an empty string C<"">.

=item C<app2_publisher>

The name of the publisher of the application, for package
managers that use this.  If unavailable this is returned
as an empty string C<"">.

=item C<app2_url>

The URL (eg. upstream URL) of the application.
If unavailable this is returned as an empty string C<"">.

=item C<app2_source_package>

For packaging systems which support this, the name of the source
package.  If unavailable this is returned as an empty string C<"">.

=item C<app2_summary>

A short (usually one line) description of the application or package.
If unavailable this is returned as an empty string C<"">.

=item C<app2_description>

A longer description of the application or package.
If unavailable this is returned as an empty string C<"">.

=back

Please read L<guestfs(3)/INSPECTION> for more details.

=item @roots = $g->inspect_os ();

This function uses other libguestfs functions and certain
heuristics to inspect the disk(s) (usually disks belonging to
a virtual machine), looking for operating systems.

The list returned is empty if no operating systems were found.

If one operating system was found, then this returns a list with
a single element, which is the name of the root filesystem of
this operating system.  It is also possible for this function
to return a list containing more than one element, indicating
a dual-boot or multi-boot virtual machine, with each element being
the root filesystem of one of the operating systems.

You can pass the root string(s) returned to other
C<$g-E<gt>inspect_get_*> functions in order to query further
information about each operating system, such as the name
and version.

This function uses other libguestfs features such as
C<$g-E<gt>mount_ro> and C<$g-E<gt>umount_all> in order to mount
and unmount filesystems and look at the contents.  This should
be called with no disks currently mounted.  The function may also
use Augeas, so any existing Augeas handle will be closed.

This function cannot decrypt encrypted disks.  The caller
must do that first (supplying the necessary keys) if the
disk is encrypted.

Please read L<guestfs(3)/INSPECTION> for more details.

See also C<$g-E<gt>list_filesystems>.

=item $flag = $g->is_blockdev ($path [, followsymlinks => $followsymlinks]);

This returns C<true> if and only if there is a block device
with the given C<path> name.

If the optional flag C<followsymlinks> is true, then a symlink
(or chain of symlinks) that ends with a block device also causes the
function to return true.

This call only looks at files within the guest filesystem.  Libguestfs
partitions and block devices (eg. F</dev/sda>) cannot be used as the
C<path> parameter of this call.

See also C<$g-E<gt>stat>.

=item $flag = $g->is_blockdev_opts ($path [, followsymlinks => $followsymlinks]);

This is an alias of L</is_blockdev>.

=cut

sub is_blockdev_opts {
  &is_blockdev (@_)
}

=pod

=item $busy = $g->is_busy ();

This always returns false.  This function is deprecated with no
replacement.  Do not use this function.

For more information on states, see L<guestfs(3)>.

=item $flag = $g->is_chardev ($path [, followsymlinks => $followsymlinks]);

This returns C<true> if and only if there is a character device
with the given C<path> name.

If the optional flag C<followsymlinks> is true, then a symlink
(or chain of symlinks) that ends with a chardev also causes the
function to return true.

See also C<$g-E<gt>stat>.

=item $flag = $g->is_chardev_opts ($path [, followsymlinks => $followsymlinks]);

This is an alias of L</is_chardev>.

=cut

sub is_chardev_opts {
  &is_chardev (@_)
}

=pod

=item $config = $g->is_config ();

This returns true iff this handle is being configured
(in the C<CONFIG> state).

For more information on states, see L<guestfs(3)>.

=item $dirflag = $g->is_dir ($path [, followsymlinks => $followsymlinks]);

This returns C<true> if and only if there is a directory
with the given C<path> name.  Note that it returns false for
other objects like files.

If the optional flag C<followsymlinks> is true, then a symlink
(or chain of symlinks) that ends with a directory also causes the
function to return true.

See also C<$g-E<gt>stat>.

=item $dirflag = $g->is_dir_opts ($path [, followsymlinks => $followsymlinks]);

This is an alias of L</is_dir>.

=cut

sub is_dir_opts {
  &is_dir (@_)
}

=pod

=item $flag = $g->is_fifo ($path [, followsymlinks => $followsymlinks]);

This returns C<true> if and only if there is a FIFO (named pipe)
with the given C<path> name.

If the optional flag C<followsymlinks> is true, then a symlink
(or chain of symlinks) that ends with a FIFO also causes the
function to return true.

See also C<$g-E<gt>stat>.

=item $flag = $g->is_fifo_opts ($path [, followsymlinks => $followsymlinks]);

This is an alias of L</is_fifo>.

=cut

sub is_fifo_opts {
  &is_fifo (@_)
}

=pod

=item $fileflag = $g->is_file ($path [, followsymlinks => $followsymlinks]);

This returns C<true> if and only if there is a regular file
with the given C<path> name.  Note that it returns false for
other objects like directories.

If the optional flag C<followsymlinks> is true, then a symlink
(or chain of symlinks) that ends with a file also causes the
function to return true.

See also C<$g-E<gt>stat>.

=item $fileflag = $g->is_file_opts ($path [, followsymlinks => $followsymlinks]);

This is an alias of L</is_file>.

=cut

sub is_file_opts {
  &is_file (@_)
}

=pod

=item $launching = $g->is_launching ();

This returns true iff this handle is launching the subprocess
(in the C<LAUNCHING> state).

For more information on states, see L<guestfs(3)>.

=item $lvflag = $g->is_lv ($mountable);

This command tests whether C<mountable> is a logical volume, and
returns true iff this is the case.

=item $ready = $g->is_ready ();

This returns true iff this handle is ready to accept commands
(in the C<READY> state).

For more information on states, see L<guestfs(3)>.

=item $flag = $g->is_socket ($path [, followsymlinks => $followsymlinks]);

This returns C<true> if and only if there is a Unix domain socket
with the given C<path> name.

If the optional flag C<followsymlinks> is true, then a symlink
(or chain of symlinks) that ends with a socket also causes the
function to return true.

See also C<$g-E<gt>stat>.

=item $flag = $g->is_socket_opts ($path [, followsymlinks => $followsymlinks]);

This is an alias of L</is_socket>.

=cut

sub is_socket_opts {
  &is_socket (@_)
}

=pod

=item $flag = $g->is_symlink ($path);

This returns C<true> if and only if there is a symbolic link
with the given C<path> name.

See also C<$g-E<gt>stat>.

=item $flag = $g->is_whole_device ($device);

This returns C<true> if and only if C<device> refers to a whole block
device. That is, not a partition or a logical device.

=item $zeroflag = $g->is_zero ($path);

This returns true iff the file exists and the file is empty or
it contains all zero bytes.

=item $zeroflag = $g->is_zero_device ($device);

This returns true iff the device exists and contains all zero bytes.

Note that for large devices this can take a long time to run.

=item %isodata = $g->isoinfo ($isofile);

This is the same as C<$g-E<gt>isoinfo_device> except that it
works for an ISO file located inside some other mounted filesystem.
Note that in the common case where you have added an ISO file
as a libguestfs device, you would I<not> call this.  Instead
you would call C<$g-E<gt>isoinfo_device>.

=item %isodata = $g->isoinfo_device ($device);

C<device> is an ISO device.  This returns a struct of information
read from the primary volume descriptor (the ISO equivalent of the
superblock) of the device.

Usually it is more efficient to use the L<isoinfo(1)> command
with the I<-d> option on the host to analyze ISO files,
instead of going through libguestfs.

For information on the primary volume descriptor fields, see
L<https://wiki.osdev.org/ISO_9660#The_Primary_Volume_Descriptor>

=item $g->journal_close ();

Close the journal handle.

This function depends on the feature C<journal>.  See also
C<$g-E<gt>feature-available>.

=item @fields = $g->journal_get ();

Read the current journal entry.  This returns all the fields
in the journal as a set of C<(attrname, attrval)> pairs.  The
C<attrname> is the field name (a string).

The C<attrval> is the field value (a binary blob, often but
not always a string).  Please note that C<attrval> is a byte
array, I<not> a \0-terminated C string.

The length of data may be truncated to the data threshold
(see: C<$g-E<gt>journal_set_data_threshold>,
C<$g-E<gt>journal_get_data_threshold>).

If you set the data threshold to unlimited (C<0>) then this call
can read a journal entry of any size, ie. it is not limited by
the libguestfs protocol.

This function depends on the feature C<journal>.  See also
C<$g-E<gt>feature-available>.

=item $threshold = $g->journal_get_data_threshold ();

Get the current data threshold for reading journal entries.
This is a hint to the journal that it may truncate data fields to
this size when reading them (note also that it may not truncate them).
If this returns C<0>, then the threshold is unlimited.

See also C<$g-E<gt>journal_set_data_threshold>.

This function depends on the feature C<journal>.  See also
C<$g-E<gt>feature-available>.

=item $usec = $g->journal_get_realtime_usec ();

Get the realtime (wallclock) timestamp of the current journal entry.

This function depends on the feature C<journal>.  See also
C<$g-E<gt>feature-available>.

=item $more = $g->journal_next ();

Move to the next journal entry.  You have to call this
at least once after opening the handle before you are able
to read data.

The returned boolean tells you if there are any more journal
records to read.  C<true> means you can read the next record
(eg. using C<$g-E<gt>journal_get>), and C<false> means you
have reached the end of the journal.

This function depends on the feature C<journal>.  See also
C<$g-E<gt>feature-available>.

=item $g->journal_open ($directory);

Open the systemd journal located in F<directory>.  Any previously
opened journal handle is closed.

The contents of the journal can be read using C<$g-E<gt>journal_next>
and C<$g-E<gt>journal_get>.

After you have finished using the journal, you should close the
handle by calling C<$g-E<gt>journal_close>.

This function depends on the feature C<journal>.  See also
C<$g-E<gt>feature-available>.

=item $g->journal_set_data_threshold ($threshold);

Set the data threshold for reading journal entries.
This is a hint to the journal that it may truncate data fields to
this size when reading them (note also that it may not truncate them).
If you set this to C<0>, then the threshold is unlimited.

See also C<$g-E<gt>journal_get_data_threshold>.

This function depends on the feature C<journal>.  See also
C<$g-E<gt>feature-available>.

=item $rskip = $g->journal_skip ($skip);

Skip forwards (C<skip E<ge> 0>) or backwards (C<skip E<lt> 0>) in the
journal.

The number of entries actually skipped is returned (note S<C<rskip E<ge> 0>>).
If this is not the same as the absolute value of the skip parameter
(C<|skip|>) you passed in then it means you have reached the end or
the start of the journal.

This function depends on the feature C<journal>.  See also
C<$g-E<gt>feature-available>.

=item $g->kill_subprocess ();

This kills the hypervisor.

Do not call this.  See: C<$g-E<gt>shutdown> instead.

I<This function is deprecated.>
In new code, use the L</shutdown> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->launch ();

You should call this after configuring the handle
(eg. adding drives) but before performing any actions.

Do not call C<$g-E<gt>launch> twice on the same handle.  Although
it will not give an error (for historical reasons), the precise
behaviour when you do this is not well defined.  Handles are
very cheap to create, so create a new one for each launch.

=item $g->lchown ($owner, $group, $path);

Change the file owner to C<owner> and group to C<group>.
This is like C<$g-E<gt>chown> but if C<path> is a symlink then
the link itself is changed, not the target.

Only numeric uid and gid are supported.  If you want to use
names, you will need to locate and parse the password file
yourself (Augeas support makes this relatively easy).

=item $g->ldmtool_create_all ();

This function scans all block devices looking for Windows
dynamic disk volumes and partitions, and creates devices
for any that were found.

Call C<$g-E<gt>list_ldm_volumes> and C<$g-E<gt>list_ldm_partitions>
to return all devices.

Note that you B<don't> normally need to call this explicitly,
since it is done automatically at C<$g-E<gt>launch> time.

This function depends on the feature C<ldm>.  See also
C<$g-E<gt>feature-available>.

=item @disks = $g->ldmtool_diskgroup_disks ($diskgroup);

Return the disks in a Windows dynamic disk group.  The C<diskgroup>
parameter should be the GUID of a disk group, one element from
the list returned by C<$g-E<gt>ldmtool_scan>.

This function depends on the feature C<ldm>.  See also
C<$g-E<gt>feature-available>.

=item $name = $g->ldmtool_diskgroup_name ($diskgroup);

Return the name of a Windows dynamic disk group.  The C<diskgroup>
parameter should be the GUID of a disk group, one element from
the list returned by C<$g-E<gt>ldmtool_scan>.

This function depends on the feature C<ldm>.  See also
C<$g-E<gt>feature-available>.

=item @volumes = $g->ldmtool_diskgroup_volumes ($diskgroup);

Return the volumes in a Windows dynamic disk group.  The C<diskgroup>
parameter should be the GUID of a disk group, one element from
the list returned by C<$g-E<gt>ldmtool_scan>.

This function depends on the feature C<ldm>.  See also
C<$g-E<gt>feature-available>.

=item $g->ldmtool_remove_all ();

This is essentially the opposite of C<$g-E<gt>ldmtool_create_all>.
It removes the device mapper mappings for all Windows dynamic disk
volumes

This function depends on the feature C<ldm>.  See also
C<$g-E<gt>feature-available>.

=item @guids = $g->ldmtool_scan ();

This function scans for Windows dynamic disks.  It returns a list
of identifiers (GUIDs) for all disk groups that were found.  These
identifiers can be passed to other C<$g-E<gt>ldmtool_*> functions.

This function scans all block devices.  To scan a subset of
block devices, call C<$g-E<gt>ldmtool_scan_devices> instead.

This function depends on the feature C<ldm>.  See also
C<$g-E<gt>feature-available>.

=item @guids = $g->ldmtool_scan_devices (\@devices);

This function scans for Windows dynamic disks.  It returns a list
of identifiers (GUIDs) for all disk groups that were found.  These
identifiers can be passed to other C<$g-E<gt>ldmtool_*> functions.

The parameter C<devices> is a list of block devices which are
scanned.  If this list is empty, all block devices are scanned.

This function depends on the feature C<ldm>.  See also
C<$g-E<gt>feature-available>.

=item $hint = $g->ldmtool_volume_hint ($diskgroup, $volume);

Return the hint field of the volume named C<volume> in the disk
group with GUID C<diskgroup>.  This may not be defined, in which
case the empty string is returned.  The hint field is often, though
not always, the name of a Windows drive, eg. C<E:>.

This function depends on the feature C<ldm>.  See also
C<$g-E<gt>feature-available>.

=item @partitions = $g->ldmtool_volume_partitions ($diskgroup, $volume);

Return the list of partitions in the volume named C<volume> in the disk
group with GUID C<diskgroup>.

This function depends on the feature C<ldm>.  See also
C<$g-E<gt>feature-available>.

=item $voltype = $g->ldmtool_volume_type ($diskgroup, $volume);

Return the type of the volume named C<volume> in the disk
group with GUID C<diskgroup>.

Possible volume types that can be returned here include:
C<simple>, C<spanned>, C<striped>, C<mirrored>, C<raid5>.
Other types may also be returned.

This function depends on the feature C<ldm>.  See also
C<$g-E<gt>feature-available>.

=item $xattr = $g->lgetxattr ($path, $name);

Get a single extended attribute from file C<path> named C<name>.
If C<path> is a symlink, then this call returns an extended
attribute from the symlink.

Normally it is better to get all extended attributes from a file
in one go by calling C<$g-E<gt>getxattrs>.  However some Linux
filesystem implementations are buggy and do not provide a way to
list out attributes.  For these filesystems (notably ntfs-3g)
you have to know the names of the extended attributes you want
in advance and call this function.

Extended attribute values are blobs of binary data.  If there
is no extended attribute named C<name>, this returns an error.

See also: C<$g-E<gt>lgetxattrs>, C<$g-E<gt>getxattr>, L<attr(5)>.

This function depends on the feature C<linuxxattrs>.  See also
C<$g-E<gt>feature-available>.

=item @xattrs = $g->lgetxattrs ($path);

This is the same as C<$g-E<gt>getxattrs>, but if C<path>
is a symbolic link, then it returns the extended attributes
of the link itself.

This function depends on the feature C<linuxxattrs>.  See also
C<$g-E<gt>feature-available>.

=item @mounttags = $g->list_9p ();

This call does nothing and returns an error.

I<This function is deprecated.>
There is no replacement.  Consult the API documentation in
L<guestfs(3)> for further information.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item @devices = $g->list_devices ();

List all the block devices.

The full block device names are returned, eg. F</dev/sda>.

See also C<$g-E<gt>list_filesystems>.

=item %labels = $g->list_disk_labels ();

If you add drives using the optional C<label> parameter
of C<$g-E<gt>add_drive_opts>, you can use this call to
map between disk labels, and raw block device and partition
names (like F</dev/sda> and F</dev/sda1>).

This returns a hashtable, where keys are the disk labels
(I<without> the F</dev/disk/guestfs> prefix), and the values
are the full raw block device and partition names
(eg. F</dev/sda> and F</dev/sda1>).

=item @devices = $g->list_dm_devices ();

List all device mapper devices.

The returned list contains F</dev/mapper/*> devices, eg. ones created
by a previous call to C<$g-E<gt>luks_open>.

Device mapper devices which correspond to logical volumes are I<not>
returned in this list.  Call C<$g-E<gt>lvs> if you want to list logical
volumes.

=item %fses = $g->list_filesystems ();

This inspection command looks for filesystems on partitions,
block devices and logical volumes, returning a list of C<mountables>
containing filesystems and their type.

The return value is a hash, where the keys are the devices
containing filesystems, and the values are the filesystem types.
For example:

 "/dev/sda1" => "ntfs"
 "/dev/sda2" => "ext2"
 "/dev/vg_guest/lv_root" => "ext4"
 "/dev/vg_guest/lv_swap" => "swap"

The key is not necessarily a block device. It may also be an opaque
‘mountable’ string which can be passed to C<$g-E<gt>mount>.

The value can have the special value "unknown", meaning the
content of the device is undetermined or empty.
"swap" means a Linux swap partition.

In libguestfs E<le> 1.36 this command ran other libguestfs commands,
which might have included C<$g-E<gt>mount> and C<$g-E<gt>umount>, and
therefore you had to use this soon after launch and only when
nothing else was mounted.  This restriction is removed in libguestfs
E<ge> 1.38.

Not all of the filesystems returned will be mountable.  In
particular, swap partitions are returned in the list.  Also
this command does not check that each filesystem
found is valid and mountable, and some filesystems might
be mountable but require special options.  Filesystems may
not all belong to a single logical operating system
(use C<$g-E<gt>inspect_os> to look for OSes).

=item @devices = $g->list_ldm_partitions ();

This function returns all Windows dynamic disk partitions
that were found at launch time.  It returns a list of
device names.

This function depends on the feature C<ldm>.  See also
C<$g-E<gt>feature-available>.

=item @devices = $g->list_ldm_volumes ();

This function returns all Windows dynamic disk volumes
that were found at launch time.  It returns a list of
device names.

This function depends on the feature C<ldm>.  See also
C<$g-E<gt>feature-available>.

=item @devices = $g->list_md_devices ();

List all Linux md devices.

=item @partitions = $g->list_partitions ();

List all the partitions detected on all block devices.

The full partition device names are returned, eg. F</dev/sda1>

This does not return logical volumes.  For that you will need to
call C<$g-E<gt>lvs>.

See also C<$g-E<gt>list_filesystems>.

=item $listing = $g->ll ($directory);

List the files in F<directory> (relative to the root directory,
there is no cwd) in the format of C<ls -la>.

This command is mostly useful for interactive sessions.  It
is I<not> intended that you try to parse the output string.

=item $listing = $g->llz ($directory);

List the files in F<directory> in the format of C<ls -laZ>.

This command is mostly useful for interactive sessions.  It
is I<not> intended that you try to parse the output string.

I<This function is deprecated.>
In new code, use the L</lgetxattrs> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->ln ($target, $linkname);

This command creates a hard link.

=item $g->ln_f ($target, $linkname);

This command creates a hard link, removing the link C<linkname>
if it exists already.

=item $g->ln_s ($target, $linkname);

This command creates a symbolic link using the C<ln -s> command.

=item $g->ln_sf ($target, $linkname);

This command creates a symbolic link using the C<ln -sf> command,
The I<-f> option removes the link (C<linkname>) if it exists already.

=item $g->lremovexattr ($xattr, $path);

This is the same as C<$g-E<gt>removexattr>, but if C<path>
is a symbolic link, then it removes an extended attribute
of the link itself.

This function depends on the feature C<linuxxattrs>.  See also
C<$g-E<gt>feature-available>.

=item @listing = $g->ls ($directory);

List the files in F<directory> (relative to the root directory,
there is no cwd).  The C<.> and C<..> entries are not returned, but
hidden files are shown.

=item $g->ls0 ($dir, $filenames);

This specialized command is used to get a listing of
the filenames in the directory C<dir>.  The list of filenames
is written to the local file F<filenames> (on the host).

In the output file, the filenames are separated by C<\0> characters.

C<.> and C<..> are not returned.  The filenames are not sorted.

=item $g->lsetxattr ($xattr, $val, $vallen, $path);

This is the same as C<$g-E<gt>setxattr>, but if C<path>
is a symbolic link, then it sets an extended attribute
of the link itself.

This function depends on the feature C<linuxxattrs>.  See also
C<$g-E<gt>feature-available>.

=item %statbuf = $g->lstat ($path);

Returns file information for the given C<path>.

This is the same as C<$g-E<gt>stat> except that if C<path>
is a symbolic link, then the link is stat-ed, not the file it
refers to.

This is the same as the L<lstat(2)> system call.

I<This function is deprecated.>
In new code, use the L</lstatns> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item @statbufs = $g->lstatlist ($path, \@names);

This call allows you to perform the C<$g-E<gt>lstat> operation
on multiple files, where all files are in the directory C<path>.
C<names> is the list of files from this directory.

On return you get a list of stat structs, with a one-to-one
correspondence to the C<names> list.  If any name did not exist
or could not be lstat'd, then the C<st_ino> field of that structure
is set to C<-1>.

This call is intended for programs that want to efficiently
list a directory contents without making many round-trips.
See also C<$g-E<gt>lxattrlist> for a similarly efficient call
for getting extended attributes.

I<This function is deprecated.>
In new code, use the L</lstatnslist> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item %statbuf = $g->lstatns ($path);

Returns file information for the given C<path>.

This is the same as C<$g-E<gt>statns> except that if C<path>
is a symbolic link, then the link is stat-ed, not the file it
refers to.

This is the same as the L<lstat(2)> system call.

=item @statbufs = $g->lstatnslist ($path, \@names);

This call allows you to perform the C<$g-E<gt>lstatns> operation
on multiple files, where all files are in the directory C<path>.
C<names> is the list of files from this directory.

On return you get a list of stat structs, with a one-to-one
correspondence to the C<names> list.  If any name did not exist
or could not be lstat'd, then the C<st_ino> field of that structure
is set to C<-1>.

This call is intended for programs that want to efficiently
list a directory contents without making many round-trips.
See also C<$g-E<gt>lxattrlist> for a similarly efficient call
for getting extended attributes.

=item $g->luks_add_key ($device, $key, $newkey, $keyslot);

This command adds a new key on LUKS device C<device>.
C<key> is any existing key, and is used to access the device.
C<newkey> is the new key to add.  C<keyslot> is the key slot
that will be replaced.

Note that if C<keyslot> already contains a key, then this
command will fail.  You have to use C<$g-E<gt>luks_kill_slot>
first to remove that key.

This function depends on the feature C<luks>.  See also
C<$g-E<gt>feature-available>.

=item $g->luks_close ($device);

This closes a LUKS device that was created earlier by
C<$g-E<gt>luks_open> or C<$g-E<gt>luks_open_ro>.  The
C<device> parameter must be the name of the LUKS mapping
device (ie. F</dev/mapper/mapname>) and I<not> the name
of the underlying block device.

This function depends on the feature C<luks>.  See also
C<$g-E<gt>feature-available>.

I<This function is deprecated.>
In new code, use the L</cryptsetup_close> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->luks_format ($device, $key, $keyslot);

This command erases existing data on C<device> and formats
the device as a LUKS encrypted device.  C<key> is the
initial key, which is added to key slot C<keyslot>.  (LUKS
supports 8 key slots, numbered 0-7).

This function depends on the feature C<luks>.  See also
C<$g-E<gt>feature-available>.

=item $g->luks_format_cipher ($device, $key, $keyslot, $cipher);

This command is the same as C<$g-E<gt>luks_format> but
it also allows you to set the C<cipher> used.

This function depends on the feature C<luks>.  See also
C<$g-E<gt>feature-available>.

=item $g->luks_kill_slot ($device, $key, $keyslot);

This command deletes the key in key slot C<keyslot> from the
encrypted LUKS device C<device>.  C<key> must be one of the
I<other> keys.

This function depends on the feature C<luks>.  See also
C<$g-E<gt>feature-available>.

=item $g->luks_open ($device, $key, $mapname);

This command opens a block device which has been encrypted
according to the Linux Unified Key Setup (LUKS) standard.

C<device> is the encrypted block device or partition.

The caller must supply one of the keys associated with the
LUKS block device, in the C<key> parameter.

This creates a new block device called F</dev/mapper/mapname>.
Reads and writes to this block device are decrypted from and
encrypted to the underlying C<device> respectively.

If this block device contains LVM volume groups, then
calling C<$g-E<gt>lvm_scan> with the C<activate>
parameter C<true> will make them visible.

Use C<$g-E<gt>list_dm_devices> to list all device mapper
devices.

This function depends on the feature C<luks>.  See also
C<$g-E<gt>feature-available>.

I<This function is deprecated.>
In new code, use the L</cryptsetup_open> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->luks_open_ro ($device, $key, $mapname);

This is the same as C<$g-E<gt>luks_open> except that a read-only
mapping is created.

This function depends on the feature C<luks>.  See also
C<$g-E<gt>feature-available>.

I<This function is deprecated.>
In new code, use the L</cryptsetup_open> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $uuid = $g->luks_uuid ($device);

This returns the UUID of the LUKS device C<device>.

This function depends on the feature C<luks>.  See also
C<$g-E<gt>feature-available>.

=item $g->lvcreate ($logvol, $volgroup, $mbytes);

This creates an LVM logical volume called C<logvol>
on the volume group C<volgroup>, with C<size> megabytes.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item $g->lvcreate_free ($logvol, $volgroup, $percent);

Create an LVM logical volume called F</dev/volgroup/logvol>,
using approximately C<percent> % of the free space remaining
in the volume group.  Most usefully, when C<percent> is C<100>
this will create the largest possible LV.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item $lv = $g->lvm_canonical_lv_name ($lvname);

This converts alternative naming schemes for LVs that you
might find to the canonical name.  For example, F</dev/mapper/VG-LV>
is converted to F</dev/VG/LV>.

This command returns an error if the C<lvname> parameter does
not refer to a logical volume.  In this case errno will be
set to C<EINVAL>.

See also C<$g-E<gt>is_lv>, C<$g-E<gt>canonical_device_name>.

=item $g->lvm_clear_filter ();

This undoes the effect of C<$g-E<gt>lvm_set_filter>.  LVM
will be able to see every block device.

This command also clears the LVM cache and performs a volume
group scan.

=item $g->lvm_remove_all ();

This command removes all LVM logical volumes, volume groups
and physical volumes.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item $g->lvm_scan ($activate);

This scans all block devices and rebuilds the list of LVM
physical volumes, volume groups and logical volumes.

If the C<activate> parameter is C<true> then newly found
volume groups and logical volumes are activated, meaning
the LV F</dev/VG/LV> devices become visible.

When a libguestfs handle is launched it scans for existing
devices, so you do not normally need to use this API.  However
it is useful when you have added a new device or deleted an
existing device (such as when the C<$g-E<gt>luks_open> API
is used).

=item $g->lvm_set_filter (\@devices);

This sets the LVM device filter so that LVM will only be
able to "see" the block devices in the list C<devices>,
and will ignore all other attached block devices.

Where disk image(s) contain duplicate PVs or VGs, this
command is useful to get LVM to ignore the duplicates, otherwise
LVM can get confused.  Note also there are two types
of duplication possible: either cloned PVs/VGs which have
identical UUIDs; or VGs that are not cloned but just happen
to have the same name.  In normal operation you cannot
create this situation, but you can do it outside LVM, eg.
by cloning disk images or by bit twiddling inside the LVM
metadata.

This command also clears the LVM cache and performs a volume
group scan.

You can filter whole block devices or individual partitions.

You cannot use this if any VG is currently in use (eg.
contains a mounted filesystem), even if you are not
filtering out that VG.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item $g->lvremove ($device);

Remove an LVM logical volume C<device>, where C<device> is
the path to the LV, such as F</dev/VG/LV>.

You can also remove all LVs in a volume group by specifying
the VG name, F</dev/VG>.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item $g->lvrename ($logvol, $newlogvol);

Rename a logical volume C<logvol> with the new name C<newlogvol>.

=item $g->lvresize ($device, $mbytes);

This resizes (expands or shrinks) an existing LVM logical
volume to C<mbytes>.  When reducing, data in the reduced part
is lost.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item $g->lvresize_free ($lv, $percent);

This expands an existing logical volume C<lv> so that it fills
C<pc> % of the remaining free space in the volume group.  Commonly
you would call this with pc = 100 which expands the logical volume
as much as possible, using all remaining free space in the volume
group.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item @logvols = $g->lvs ();

List all the logical volumes detected.  This is the equivalent
of the L<lvs(8)> command.

This returns a list of the logical volume device names
(eg. F</dev/VolGroup00/LogVol00>).

See also C<$g-E<gt>lvs_full>, C<$g-E<gt>list_filesystems>.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item @logvols = $g->lvs_full ();

List all the logical volumes detected.  This is the equivalent
of the L<lvs(8)> command.  The "full" version includes all fields.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item $uuid = $g->lvuuid ($device);

This command returns the UUID of the LVM LV C<device>.

=item @xattrs = $g->lxattrlist ($path, \@names);

This call allows you to get the extended attributes
of multiple files, where all files are in the directory C<path>.
C<names> is the list of files from this directory.

On return you get a flat list of xattr structs which must be
interpreted sequentially.  The first xattr struct always has a zero-length
C<attrname>.  C<attrval> in this struct is zero-length
to indicate there was an error doing C<$g-E<gt>lgetxattr> for this
file, I<or> is a C string which is a decimal number
(the number of following attributes for this file, which could
be C<"0">).  Then after the first xattr struct are the
zero or more attributes for the first named file.
This repeats for the second and subsequent files.

This call is intended for programs that want to efficiently
list a directory contents without making many round-trips.
See also C<$g-E<gt>lstatlist> for a similarly efficient call
for getting standard stats.

This function depends on the feature C<linuxxattrs>.  See also
C<$g-E<gt>feature-available>.

=item $disks = $g->max_disks ();

Return the maximum number of disks that may be added to a
handle (eg. by C<$g-E<gt>add_drive_opts> and similar calls).

This function was added in libguestfs 1.19.7.  In previous
versions of libguestfs the limit was 25.

See L<guestfs(3)/MAXIMUM NUMBER OF DISKS> for additional
information on this topic.

=item $g->md_create ($name, \@devices [, missingbitmap => $missingbitmap] [, nrdevices => $nrdevices] [, spare => $spare] [, chunk => $chunk] [, level => $level]);

Create a Linux md (RAID) device named C<name> on the devices
in the list C<devices>.

The optional parameters are:

=over 4

=item C<missingbitmap>

A bitmap of missing devices.  If a bit is set it means that a
missing device is added to the array.  The least significant bit
corresponds to the first device in the array.

As examples:

If C<devices = ["/dev/sda"]> and C<missingbitmap = 0x1> then
the resulting array would be C<[E<lt>missingE<gt>, "/dev/sda"]>.

If C<devices = ["/dev/sda"]> and C<missingbitmap = 0x2> then
the resulting array would be C<["/dev/sda", E<lt>missingE<gt>]>.

This defaults to C<0> (no missing devices).

The length of C<devices> + the number of bits set in
C<missingbitmap> must equal C<nrdevices> + C<spare>.

=item C<nrdevices>

The number of active RAID devices.

If not set, this defaults to the length of C<devices> plus
the number of bits set in C<missingbitmap>.

=item C<spare>

The number of spare devices.

If not set, this defaults to C<0>.

=item C<chunk>

The chunk size in bytes.

The C<chunk> parameter does not make sense, and should not be specified,
when C<level> is C<raid1> (which is the default; see below).

=item C<level>

The RAID level, which can be one of:
C<linear>, C<raid0>, C<0>, C<stripe>, C<raid1>, C<1>, C<mirror>,
C<raid4>, C<4>, C<raid5>, C<5>, C<raid6>, C<6>, C<raid10>, C<10>.
Some of these are synonymous, and more levels may be added in future.

If not set, this defaults to C<raid1>.

=back

This function depends on the feature C<mdadm>.  See also
C<$g-E<gt>feature-available>.

=item %info = $g->md_detail ($md);

This command exposes the output of C<mdadm -DY E<lt>mdE<gt>>.
The following fields are usually present in the returned hash.
Other fields may also be present.

=over

=item C<level>

The raid level of the MD device.

=item C<devices>

The number of underlying devices in the MD device.

=item C<metadata>

The metadata version used.

=item C<uuid>

The UUID of the MD device.

=item C<name>

The name of the MD device.

=back

This function depends on the feature C<mdadm>.  See also
C<$g-E<gt>feature-available>.

=item @devices = $g->md_stat ($md);

This call returns a list of the underlying devices which make
up the single software RAID array device C<md>.

To get a list of software RAID devices, call C<$g-E<gt>list_md_devices>.

Each structure returned corresponds to one device along with
additional status information:

=over 4

=item C<mdstat_device>

The name of the underlying device.

=item C<mdstat_index>

The index of this device within the array.

=item C<mdstat_flags>

Flags associated with this device.  This is a string containing
(in no specific order) zero or more of the following flags:

=over 4

=item C<W>

write-mostly

=item C<F>

device is faulty

=item C<S>

device is a RAID spare

=item C<R>

replacement

=back

=back

This function depends on the feature C<mdadm>.  See also
C<$g-E<gt>feature-available>.

=item $g->md_stop ($md);

This command deactivates the MD array named C<md>.  The
device is stopped, but it is not destroyed or zeroed.

This function depends on the feature C<mdadm>.  See also
C<$g-E<gt>feature-available>.

=item $g->mkdir ($path);

Create a directory named C<path>.

=item $g->mkdir_mode ($path, $mode);

This command creates a directory, setting the initial permissions
of the directory to C<mode>.

For common Linux filesystems, the actual mode which is set will
be C<mode & ~umask & 01777>.  Non-native-Linux filesystems may
interpret the mode in other ways.

See also C<$g-E<gt>mkdir>, C<$g-E<gt>umask>

=item $g->mkdir_p ($path);

Create a directory named C<path>, creating any parent directories
as necessary.  This is like the C<mkdir -p> shell command.

=item $dir = $g->mkdtemp ($tmpl);

This command creates a temporary directory.  The
C<tmpl> parameter should be a full pathname for the
temporary directory name with the final six characters being
"XXXXXX".

For example: "/tmp/myprogXXXXXX" or "/Temp/myprogXXXXXX",
the second one being suitable for Windows filesystems.

The name of the temporary directory that was created
is returned.

The temporary directory is created with mode 0700
and is owned by root.

The caller is responsible for deleting the temporary
directory and its contents after use.

See also: L<mkdtemp(3)>

=item $g->mke2fs ($device [, blockscount => $blockscount] [, blocksize => $blocksize] [, fragsize => $fragsize] [, blockspergroup => $blockspergroup] [, numberofgroups => $numberofgroups] [, bytesperinode => $bytesperinode] [, inodesize => $inodesize] [, journalsize => $journalsize] [, numberofinodes => $numberofinodes] [, stridesize => $stridesize] [, stripewidth => $stripewidth] [, maxonlineresize => $maxonlineresize] [, reservedblockspercentage => $reservedblockspercentage] [, mmpupdateinterval => $mmpupdateinterval] [, journaldevice => $journaldevice] [, label => $label] [, lastmounteddir => $lastmounteddir] [, creatoros => $creatoros] [, fstype => $fstype] [, usagetype => $usagetype] [, uuid => $uuid] [, forcecreate => $forcecreate] [, writesbandgrouponly => $writesbandgrouponly] [, lazyitableinit => $lazyitableinit] [, lazyjournalinit => $lazyjournalinit] [, testfs => $testfs] [, discard => $discard] [, quotatype => $quotatype] [, extent => $extent] [, filetype => $filetype] [, flexbg => $flexbg] [, hasjournal => $hasjournal] [, journaldev => $journaldev] [, largefile => $largefile] [, quota => $quota] [, resizeinode => $resizeinode] [, sparsesuper => $sparsesuper] [, uninitbg => $uninitbg]);

C<mke2fs> is used to create an ext2, ext3, or ext4 filesystem
on C<device>.

The optional C<blockscount> is the size of the filesystem in blocks.
If omitted it defaults to the size of C<device>.  Note if the
filesystem is too small to contain a journal, C<mke2fs> will
silently create an ext2 filesystem instead.

=item $g->mke2fs_J ($fstype, $blocksize, $device, $journal);

This creates an ext2/3/4 filesystem on C<device> with
an external journal on C<journal>.  It is equivalent
to the command:

 mke2fs -t fstype -b blocksize -J device=<journal> <device>

See also C<$g-E<gt>mke2journal>.

I<This function is deprecated.>
In new code, use the L</mke2fs> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->mke2fs_JL ($fstype, $blocksize, $device, $label);

This creates an ext2/3/4 filesystem on C<device> with
an external journal on the journal labeled C<label>.

See also C<$g-E<gt>mke2journal_L>.

I<This function is deprecated.>
In new code, use the L</mke2fs> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->mke2fs_JU ($fstype, $blocksize, $device, $uuid);

This creates an ext2/3/4 filesystem on C<device> with
an external journal on the journal with UUID C<uuid>.

See also C<$g-E<gt>mke2journal_U>.

This function depends on the feature C<linuxfsuuid>.  See also
C<$g-E<gt>feature-available>.

I<This function is deprecated.>
In new code, use the L</mke2fs> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->mke2journal ($blocksize, $device);

This creates an ext2 external journal on C<device>.  It is equivalent
to the command:

 mke2fs -O journal_dev -b blocksize device

I<This function is deprecated.>
In new code, use the L</mke2fs> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->mke2journal_L ($blocksize, $label, $device);

This creates an ext2 external journal on C<device> with label C<label>.

I<This function is deprecated.>
In new code, use the L</mke2fs> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->mke2journal_U ($blocksize, $uuid, $device);

This creates an ext2 external journal on C<device> with UUID C<uuid>.

This function depends on the feature C<linuxfsuuid>.  See also
C<$g-E<gt>feature-available>.

I<This function is deprecated.>
In new code, use the L</mke2fs> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->mkfifo ($mode, $path);

This call creates a FIFO (named pipe) called C<path> with
mode C<mode>.  It is just a convenient wrapper around
C<$g-E<gt>mknod>.

Unlike with C<$g-E<gt>mknod>, C<mode> B<must> contain only permissions
bits.

The mode actually set is affected by the umask.

This function depends on the feature C<mknod>.  See also
C<$g-E<gt>feature-available>.

=item $g->mkfs ($fstype, $device [, blocksize => $blocksize] [, features => $features] [, inode => $inode] [, sectorsize => $sectorsize] [, label => $label]);

This function creates a filesystem on C<device>.  The filesystem
type is C<fstype>, for example C<ext3>.

The optional arguments are:

=over 4

=item C<blocksize>

The filesystem block size.  Supported block sizes depend on the
filesystem type, but typically they are C<1024>, C<2048> or C<4096>
for Linux ext2/3 filesystems.

For VFAT and NTFS the C<blocksize> parameter is treated as
the requested cluster size.

For UFS block sizes, please see L<mkfs.ufs(8)>.

=item C<features>

This passes the I<-O> parameter to the external mkfs program.

For certain filesystem types, this allows extra filesystem
features to be selected.  See L<mke2fs(8)> and L<mkfs.ufs(8)>
for more details.

You cannot use this optional parameter with the C<gfs> or
C<gfs2> filesystem type.

=item C<inode>

This passes the I<-I> parameter to the external L<mke2fs(8)> program
which sets the inode size (only for ext2/3/4 filesystems at present).

=item C<sectorsize>

This passes the I<-S> parameter to external L<mkfs.ufs(8)> program,
which sets sector size for ufs filesystem.

=back

=item $g->mkfs_opts ($fstype, $device [, blocksize => $blocksize] [, features => $features] [, inode => $inode] [, sectorsize => $sectorsize] [, label => $label]);

This is an alias of L</mkfs>.

=cut

sub mkfs_opts {
  &mkfs (@_)
}

=pod

=item $g->mkfs_b ($fstype, $blocksize, $device);

This call is similar to C<$g-E<gt>mkfs>, but it allows you to
control the block size of the resulting filesystem.  Supported
block sizes depend on the filesystem type, but typically they
are C<1024>, C<2048> or C<4096> only.

For VFAT and NTFS the C<blocksize> parameter is treated as
the requested cluster size.

I<This function is deprecated.>
In new code, use the L</mkfs> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->mkfs_btrfs (\@devices [, allocstart => $allocstart] [, bytecount => $bytecount] [, datatype => $datatype] [, leafsize => $leafsize] [, label => $label] [, metadata => $metadata] [, nodesize => $nodesize] [, sectorsize => $sectorsize]);

Create a btrfs filesystem, allowing all configurables to be set.
For more information on the optional arguments, see L<mkfs.btrfs(8)>.

Since btrfs filesystems can span multiple devices, this takes a
non-empty list of devices.

To create general filesystems, use C<$g-E<gt>mkfs>.

This function depends on the feature C<btrfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->mklost_and_found ($mountpoint);

Make the C<lost+found> directory, normally in the root directory
of an ext2/3/4 filesystem.  C<mountpoint> is the directory under
which we try to create the C<lost+found> directory.

=item $g->mkmountpoint ($exemptpath);

C<$g-E<gt>mkmountpoint> and C<$g-E<gt>rmmountpoint> are
specialized calls that can be used to create extra mountpoints
before mounting the first filesystem.

These calls are I<only> necessary in some very limited circumstances,
mainly the case where you want to mount a mix of unrelated and/or
read-only filesystems together.

For example, live CDs often contain a "Russian doll" nest of
filesystems, an ISO outer layer, with a squashfs image inside, with
an ext2/3 image inside that.  You can unpack this as follows
in guestfish:

 add-ro Fedora-11-i686-Live.iso
 run
 mkmountpoint /cd
 mkmountpoint /sqsh
 mkmountpoint /ext3fs
 mount /dev/sda /cd
 mount-loop /cd/LiveOS/squashfs.img /sqsh
 mount-loop /sqsh/LiveOS/ext3fs.img /ext3fs

The inner filesystem is now unpacked under the /ext3fs mountpoint.

C<$g-E<gt>mkmountpoint> is not compatible with C<$g-E<gt>umount_all>.
You may get unexpected errors if you try to mix these calls.  It is
safest to manually unmount filesystems and remove mountpoints after use.

C<$g-E<gt>umount_all> unmounts filesystems by sorting the paths
longest first, so for this to work for manual mountpoints, you
must ensure that the innermost mountpoints have the longest
pathnames, as in the example code above.

For more details see L<https://bugzilla.redhat.com/show_bug.cgi?id=599503>

Autosync [see C<$g-E<gt>set_autosync>, this is set by default on
handles] can cause C<$g-E<gt>umount_all> to be called when the handle
is closed which can also trigger these issues.

=item $g->mknod ($mode, $devmajor, $devminor, $path);

This call creates block or character special devices, or
named pipes (FIFOs).

The C<mode> parameter should be the mode, using the standard
constants.  C<devmajor> and C<devminor> are the
device major and minor numbers, only used when creating block
and character special devices.

Note that, just like L<mknod(2)>, the mode must be bitwise
OR'd with S_IFBLK, S_IFCHR, S_IFIFO or S_IFSOCK (otherwise this call
just creates a regular file).  These constants are
available in the standard Linux header files, or you can use
C<$g-E<gt>mknod_b>, C<$g-E<gt>mknod_c> or C<$g-E<gt>mkfifo>
which are wrappers around this command which bitwise OR
in the appropriate constant for you.

The mode actually set is affected by the umask.

This function depends on the feature C<mknod>.  See also
C<$g-E<gt>feature-available>.

=item $g->mknod_b ($mode, $devmajor, $devminor, $path);

This call creates a block device node called C<path> with
mode C<mode> and device major/minor C<devmajor> and C<devminor>.
It is just a convenient wrapper around C<$g-E<gt>mknod>.

Unlike with C<$g-E<gt>mknod>, C<mode> B<must> contain only permissions
bits.

The mode actually set is affected by the umask.

This function depends on the feature C<mknod>.  See also
C<$g-E<gt>feature-available>.

=item $g->mknod_c ($mode, $devmajor, $devminor, $path);

This call creates a char device node called C<path> with
mode C<mode> and device major/minor C<devmajor> and C<devminor>.
It is just a convenient wrapper around C<$g-E<gt>mknod>.

Unlike with C<$g-E<gt>mknod>, C<mode> B<must> contain only permissions
bits.

The mode actually set is affected by the umask.

This function depends on the feature C<mknod>.  See also
C<$g-E<gt>feature-available>.

=item $g->mksquashfs ($path, $filename [, compress => $compress] [, excludes => $excludes]);

Create a squashfs filesystem for the specified C<path>.

The optional C<compress> flag controls compression.  If not given,
then the output compressed using C<gzip>.  Otherwise one
of the following strings may be given to select the compression
type of the squashfs: C<gzip>, C<lzma>, C<lzo>, C<lz4>, C<xz>.

The other optional arguments are:

=over 4

=item C<excludes>

A list of wildcards.  Files are excluded if they match any of the
wildcards.

=back

Please note that this API may fail when used to compress directories
with large files, such as the resulting squashfs will be over 3GB big.

This function depends on the feature C<squashfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->mkswap ($device [, label => $label] [, uuid => $uuid]);

Create a Linux swap partition on C<device>.

The option arguments C<label> and C<uuid> allow you to set the
label and/or UUID of the new swap partition.

=item $g->mkswap_opts ($device [, label => $label] [, uuid => $uuid]);

This is an alias of L</mkswap>.

=cut

sub mkswap_opts {
  &mkswap (@_)
}

=pod

=item $g->mkswap_L ($label, $device);

Create a swap partition on C<device> with label C<label>.

Note that you cannot attach a swap label to a block device
(eg. F</dev/sda>), just to a partition.  This appears to be
a limitation of the kernel or swap tools.

I<This function is deprecated.>
In new code, use the L</mkswap> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->mkswap_U ($uuid, $device);

Create a swap partition on C<device> with UUID C<uuid>.

This function depends on the feature C<linuxfsuuid>.  See also
C<$g-E<gt>feature-available>.

I<This function is deprecated.>
In new code, use the L</mkswap> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->mkswap_file ($path);

Create a swap file.

This command just writes a swap file signature to an existing
file.  To create the file itself, use something like C<$g-E<gt>fallocate>.

=item $path = $g->mktemp ($tmpl [, suffix => $suffix]);

This command creates a temporary file.  The
C<tmpl> parameter should be a full pathname for the
temporary directory name with the final six characters being
"XXXXXX".

For example: "/tmp/myprogXXXXXX" or "/Temp/myprogXXXXXX",
the second one being suitable for Windows filesystems.

The name of the temporary file that was created
is returned.

The temporary file is created with mode 0600
and is owned by root.

The caller is responsible for deleting the temporary
file after use.

If the optional C<suffix> parameter is given, then the suffix
(eg. C<.txt>) is appended to the temporary name.

See also: C<$g-E<gt>mkdtemp>.

=item $g->modprobe ($modulename);

This loads a kernel module in the appliance.

This function depends on the feature C<linuxmodules>.  See also
C<$g-E<gt>feature-available>.

=item $g->mount ($mountable, $mountpoint);

Mount a guest disk at a position in the filesystem.  Block devices
are named F</dev/sda>, F</dev/sdb> and so on, as they were added to
the guest.  If those block devices contain partitions, they will have
the usual names (eg. F</dev/sda1>).  Also LVM F</dev/VG/LV>-style
names can be used, or ‘mountable’ strings returned by
C<$g-E<gt>list_filesystems> or C<$g-E<gt>inspect_get_mountpoints>.

The rules are the same as for L<mount(2)>:  A filesystem must
first be mounted on F</> before others can be mounted.  Other
filesystems can only be mounted on directories which already
exist.

The mounted filesystem is writable, if we have sufficient permissions
on the underlying device.

Before libguestfs 1.13.16, this call implicitly added the options
C<sync> and C<noatime>.  The C<sync> option greatly slowed
writes and caused many problems for users.  If your program
might need to work with older versions of libguestfs, use
C<$g-E<gt>mount_options> instead (using an empty string for the
first parameter if you don't want any options).

=item $g->mount_9p ($mounttag, $mountpoint [, options => $options]);

This call does nothing and returns an error.

I<This function is deprecated.>
There is no replacement.  Consult the API documentation in
L<guestfs(3)> for further information.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->mount_local ($localmountpoint [, readonly => $readonly] [, options => $options] [, cachetimeout => $cachetimeout] [, debugcalls => $debugcalls]);

This call exports the libguestfs-accessible filesystem to
a local mountpoint (directory) called C<localmountpoint>.
Ordinary reads and writes to files and directories under
C<localmountpoint> are redirected through libguestfs.

If the optional C<readonly> flag is set to true, then
writes to the filesystem return error C<EROFS>.

C<options> is a comma-separated list of mount options.
See L<guestmount(1)> for some useful options.

C<cachetimeout> sets the timeout (in seconds) for cached directory
entries.  The default is 60 seconds.  See L<guestmount(1)>
for further information.

If C<debugcalls> is set to true, then additional debugging
information is generated for every FUSE call.

When C<$g-E<gt>mount_local> returns, the filesystem is ready,
but is not processing requests (access to it will block).  You
have to call C<$g-E<gt>mount_local_run> to run the main loop.

See L<guestfs(3)/MOUNT LOCAL> for full documentation.

=item $g->mount_local_run ();

Run the main loop which translates kernel calls to libguestfs
calls.

This should only be called after C<$g-E<gt>mount_local>
returns successfully.  The call will not return until the
filesystem is unmounted.

B<Note> you must I<not> make concurrent libguestfs calls
on the same handle from another thread.

You may call this from a different thread than the one which
called C<$g-E<gt>mount_local>, subject to the usual rules
for threads and libguestfs (see
L<guestfs(3)/MULTIPLE HANDLES AND MULTIPLE THREADS>).

See L<guestfs(3)/MOUNT LOCAL> for full documentation.

=item $g->mount_loop ($file, $mountpoint);

This command lets you mount F<file> (a filesystem image
in a file) on a mount point.  It is entirely equivalent to
the command C<mount -o loop file mountpoint>.

=item $g->mount_options ($options, $mountable, $mountpoint);

This is the same as the C<$g-E<gt>mount> command, but it
allows you to set the mount options as for the
L<mount(8)> I<-o> flag.

If the C<options> parameter is an empty string, then
no options are passed (all options default to whatever
the filesystem uses).

=item $g->mount_ro ($mountable, $mountpoint);

This is the same as the C<$g-E<gt>mount> command, but it
mounts the filesystem with the read-only (I<-o ro>) flag.

=item $g->mount_vfs ($options, $vfstype, $mountable, $mountpoint);

This is the same as the C<$g-E<gt>mount> command, but it
allows you to set both the mount options and the vfstype
as for the L<mount(8)> I<-o> and I<-t> flags.

=item $device = $g->mountable_device ($mountable);

Returns the device name of a mountable. In quite a lot of
cases, the mountable is the device name.

However this doesn't apply for btrfs subvolumes, where the
mountable is a combination of both the device name and the
subvolume path (see also C<$g-E<gt>mountable_subvolume> to
extract the subvolume path of the mountable if any).

=item $subvolume = $g->mountable_subvolume ($mountable);

Returns the subvolume path of a mountable. Btrfs subvolumes
mountables are a combination of both the device name and the
subvolume path (see also C<$g-E<gt>mountable_device> to extract
the device of the mountable).

If the mountable does not represent a btrfs subvolume, then
this function fails and the C<errno> is set to C<EINVAL>.

=item %mps = $g->mountpoints ();

This call is similar to C<$g-E<gt>mounts>.  That call returns
a list of devices.  This one returns a hash table (map) of
device name to directory where the device is mounted.

=item @devices = $g->mounts ();

This returns the list of currently mounted filesystems.  It returns
the list of devices (eg. F</dev/sda1>, F</dev/VG/LV>).

Some internal mounts are not shown.

See also: C<$g-E<gt>mountpoints>

=item $g->mv ($src, $dest);

This moves a file from C<src> to C<dest> where C<dest> is
either a destination filename or destination directory.

See also: C<$g-E<gt>rename>.

=item $nrdisks = $g->nr_devices ();

This returns the number of whole block devices that were
added.  This is the same as the number of devices that would
be returned if you called C<$g-E<gt>list_devices>.

To find out the maximum number of devices that could be added,
call C<$g-E<gt>max_disks>.

=item $status = $g->ntfs_3g_probe ($rw, $device);

This command runs the L<ntfs-3g.probe(8)> command which probes
an NTFS C<device> for mountability.  (Not all NTFS volumes can
be mounted read-write, and some cannot be mounted at all).

C<rw> is a boolean flag.  Set it to true if you want to test
if the volume can be mounted read-write.  Set it to false if
you want to test if the volume can be mounted read-only.

The return value is an integer which C<0> if the operation
would succeed, or some non-zero value documented in the
L<ntfs-3g.probe(8)> manual page.

This function depends on the feature C<ntfs3g>.  See also
C<$g-E<gt>feature-available>.

=item $g->ntfscat_i ($device, $inode, $filename);

Download a file given its inode from a NTFS filesystem and save it as
F<filename> on the local machine.

This allows to download some otherwise inaccessible files such as the ones
within the C<$Extend> folder.

The filesystem from which to extract the file must be unmounted,
otherwise the call will fail.

=item $g->ntfsclone_in ($backupfile, $device);

Restore the C<backupfile> (from a previous call to
C<$g-E<gt>ntfsclone_out>) to C<device>, overwriting
any existing contents of this device.

This function depends on the feature C<ntfs3g>.  See also
C<$g-E<gt>feature-available>.

=item $g->ntfsclone_out ($device, $backupfile [, metadataonly => $metadataonly] [, rescue => $rescue] [, ignorefscheck => $ignorefscheck] [, preservetimestamps => $preservetimestamps] [, force => $force]);

Stream the NTFS filesystem C<device> to the local file
C<backupfile>.  The format used for the backup file is a
special format used by the L<ntfsclone(8)> tool.

If the optional C<metadataonly> flag is true, then I<only> the
metadata is saved, losing all the user data (this is useful
for diagnosing some filesystem problems).

The optional C<rescue>, C<ignorefscheck>, C<preservetimestamps>
and C<force> flags have precise meanings detailed in the
L<ntfsclone(8)> man page.

Use C<$g-E<gt>ntfsclone_in> to restore the file back to a
libguestfs device.

This function depends on the feature C<ntfs3g>.  See also
C<$g-E<gt>feature-available>.

=item $g->ntfsfix ($device [, clearbadsectors => $clearbadsectors]);

This command repairs some fundamental NTFS inconsistencies,
resets the NTFS journal file, and schedules an NTFS consistency
check for the first boot into Windows.

This is I<not> an equivalent of Windows C<chkdsk>.  It does I<not>
scan the filesystem for inconsistencies.

The optional C<clearbadsectors> flag clears the list of bad sectors.
This is useful after cloning a disk with bad sectors to a new disk.

This function depends on the feature C<ntfs3g>.  See also
C<$g-E<gt>feature-available>.

=item $g->ntfsresize ($device [, size => $size] [, force => $force]);

This command resizes an NTFS filesystem, expanding or
shrinking it to the size of the underlying device.

The optional parameters are:

=over 4

=item C<size>

The new size (in bytes) of the filesystem.  If omitted, the filesystem
is resized to fit the container (eg. partition).

=item C<force>

If this option is true, then force the resize of the filesystem
even if the filesystem is marked as requiring a consistency check.

After the resize operation, the filesystem is always marked
as requiring a consistency check (for safety).  You have to boot
into Windows to perform this check and clear this condition.
If you I<don't> set the C<force> option then it is not
possible to call C<$g-E<gt>ntfsresize> multiple times on a
single filesystem without booting into Windows between each resize.

=back

See also L<ntfsresize(8)>.

This function depends on the feature C<ntfsprogs>.  See also
C<$g-E<gt>feature-available>.

=item $g->ntfsresize_opts ($device [, size => $size] [, force => $force]);

This is an alias of L</ntfsresize>.

=cut

sub ntfsresize_opts {
  &ntfsresize (@_)
}

=pod

=item $g->ntfsresize_size ($device, $size);

This command is the same as C<$g-E<gt>ntfsresize> except that it
allows you to specify the new size (in bytes) explicitly.

This function depends on the feature C<ntfsprogs>.  See also
C<$g-E<gt>feature-available>.

I<This function is deprecated.>
In new code, use the L</ntfsresize> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->parse_environment ();

Parse the program’s environment and set flags in the handle
accordingly.  For example if C<LIBGUESTFS_DEBUG=1> then the
‘verbose’ flag is set in the handle.

I<Most programs do not need to call this>.  It is done implicitly
when you call C<$g-E<gt>create>.

See L<guestfs(3)/ENVIRONMENT VARIABLES> for a list of environment
variables that can affect libguestfs handles.  See also
L<guestfs(3)/guestfs_create_flags>, and
C<$g-E<gt>parse_environment_list>.

=item $g->parse_environment_list (\@environment);

Parse the list of strings in the argument C<environment>
and set flags in the handle accordingly.
For example if C<LIBGUESTFS_DEBUG=1> is a string in the list,
then the ‘verbose’ flag is set in the handle.

This is the same as C<$g-E<gt>parse_environment> except that
it parses an explicit list of strings instead of the program's
environment.

=item $g->part_add ($device, $prlogex, $startsect, $endsect);

This command adds a partition to C<device>.  If there is no partition
table on the device, call C<$g-E<gt>part_init> first.

The C<prlogex> parameter is the type of partition.  Normally you
should pass C<p> or C<primary> here, but MBR partition tables also
support C<l> (or C<logical>) and C<e> (or C<extended>) partition
types.

C<startsect> and C<endsect> are the start and end of the partition
in I<sectors>.  C<endsect> may be negative, which means it counts
backwards from the end of the disk (C<-1> is the last sector).

Creating a partition which covers the whole disk is not so easy.
Use C<$g-E<gt>part_disk> to do that.

=item $g->part_del ($device, $partnum);

This command deletes the partition numbered C<partnum> on C<device>.

Note that in the case of MBR partitioning, deleting an
extended partition also deletes any logical partitions
it contains.

=item $g->part_disk ($device, $parttype);

This command is simply a combination of C<$g-E<gt>part_init>
followed by C<$g-E<gt>part_add> to create a single primary partition
covering the whole disk.

C<parttype> is the partition table type, usually C<mbr> or C<gpt>,
but other possible values are described in C<$g-E<gt>part_init>.

=item $g->part_expand_gpt ($device);

Move backup GPT data structures to the end of the disk.
This is useful in case of in-place image expand
since disk space after backup GPT header is not usable.
This is equivalent to C<sgdisk -e>.

See also L<sgdisk(8)>.

This function depends on the feature C<gdisk>.  See also
C<$g-E<gt>feature-available>.

=item $bootable = $g->part_get_bootable ($device, $partnum);

This command returns true if the partition C<partnum> on
C<device> has the bootable flag set.

See also C<$g-E<gt>part_set_bootable>.

=item $guid = $g->part_get_disk_guid ($device);

Return the disk identifier (GUID) of a GPT-partitioned C<device>.
Behaviour is undefined for other partition types.

=item $attributes = $g->part_get_gpt_attributes ($device, $partnum);

Return the attribute flags of numbered GPT partition C<partnum>.
An error is returned for MBR partitions.

=item $guid = $g->part_get_gpt_guid ($device, $partnum);

Return the GUID of numbered GPT partition C<partnum>.

=item $guid = $g->part_get_gpt_type ($device, $partnum);

Return the type GUID of numbered GPT partition C<partnum>.

=item $idbyte = $g->part_get_mbr_id ($device, $partnum);

Returns the MBR type byte (also known as the ID byte) from
the numbered partition C<partnum>.

Note that only MBR (old DOS-style) partitions have type bytes.
You will get undefined results for other partition table
types (see C<$g-E<gt>part_get_parttype>).

=item $partitiontype = $g->part_get_mbr_part_type ($device, $partnum);

This returns the partition type of an MBR partition
numbered C<partnum> on device C<device>.

It returns C<primary>, C<logical>, or C<extended>.

=item $name = $g->part_get_name ($device, $partnum);

This gets the partition name on partition numbered C<partnum> on
device C<device>.  Note that partitions are numbered from 1.

The partition name can only be read on certain types of partition
table.  This works on C<gpt> but not on C<mbr> partitions.

=item $parttype = $g->part_get_parttype ($device);

This command examines the partition table on C<device> and
returns the partition table type (format) being used.

Common return values include: C<msdos> (a DOS/Windows style MBR
partition table), C<gpt> (a GPT/EFI-style partition table).  Other
values are possible, although unusual.  See C<$g-E<gt>part_init>
for a full list.

=item $g->part_init ($device, $parttype);

This creates an empty partition table on C<device> of one of the
partition types listed below.  Usually C<parttype> should be
either C<msdos> or C<gpt> (for large disks).

Initially there are no partitions.  Following this, you should
call C<$g-E<gt>part_add> for each partition required.

Possible values for C<parttype> are:

=over 4

=item C<efi>

=item C<gpt>

Intel EFI / GPT partition table.

This is recommended for >= 2 TB partitions that will be accessed
from Linux and Intel-based Mac OS X.  It also has limited backwards
compatibility with the C<mbr> format.

=item C<mbr>

=item C<msdos>

The standard PC "Master Boot Record" (MBR) format used
by MS-DOS and Windows.  This partition type will B<only> work
for device sizes up to 2 TB.  For large disks we recommend
using C<gpt>.

=back

Other partition table types that may work but are not
supported include:

=over 4

=item C<aix>

AIX disk labels.

=item C<amiga>

=item C<rdb>

Amiga "Rigid Disk Block" format.

=item C<bsd>

BSD disk labels.

=item C<dasd>

DASD, used on IBM mainframes.

=item C<dvh>

MIPS/SGI volumes.

=item C<mac>

Old Mac partition format.  Modern Macs use C<gpt>.

=item C<pc98>

NEC PC-98 format, common in Japan apparently.

=item C<sun>

Sun disk labels.

=back

=item @partitions = $g->part_list ($device);

This command parses the partition table on C<device> and
returns the list of partitions found.

The fields in the returned structure are:

=over 4

=item C<part_num>

Partition number, counting from 1.

=item C<part_start>

Start of the partition I<in bytes>.  To get sectors you have to
divide by the device’s sector size, see C<$g-E<gt>blockdev_getss>.

=item C<part_end>

End of the partition in bytes.

=item C<part_size>

Size of the partition in bytes.

=back

=item $g->part_resize ($device, $partnum, $endsect);

This command resizes the partition numbered C<partnum> on C<device>
by moving the end position.

Note that this does not modify any filesystem present in the partition.
If you wish to do this, you will need to use filesystem resizing
commands like C<$g-E<gt>resize2fs>.

When growing a partition you will want to grow the filesystem
afterwards, but when shrinking, you need to shrink the filesystem
before the partition.

=item $g->part_set_bootable ($device, $partnum, $bootable);

This sets the bootable flag on partition numbered C<partnum> on
device C<device>.  Note that partitions are numbered from 1.

The bootable flag is used by some operating systems (notably
Windows) to determine which partition to boot from.  It is by
no means universally recognized.

=item $g->part_set_disk_guid ($device, $guid);

Set the disk identifier (GUID) of a GPT-partitioned C<device> to C<guid>.
Return an error if the partition table of C<device> isn't GPT,
or if C<guid> is not a valid GUID.

=item $g->part_set_disk_guid_random ($device);

Set the disk identifier (GUID) of a GPT-partitioned C<device> to
a randomly generated value.
Return an error if the partition table of C<device> isn't GPT.

=item $g->part_set_gpt_attributes ($device, $partnum, $attributes);

Set the attribute flags of numbered GPT partition C<partnum> to C<attributes>. Return an
error if the partition table of C<device> isn't GPT.

See L<https://en.wikipedia.org/wiki/GUID_Partition_Table#Partition_entries>
for a useful list of partition attributes.

=item $g->part_set_gpt_guid ($device, $partnum, $guid);

Set the GUID of numbered GPT partition C<partnum> to C<guid>.  Return an
error if the partition table of C<device> isn't GPT, or if C<guid> is not a
valid GUID.

=item $g->part_set_gpt_type ($device, $partnum, $guid);

Set the type GUID of numbered GPT partition C<partnum> to C<guid>. Return an
error if the partition table of C<device> isn't GPT, or if C<guid> is not a
valid GUID.

See L<https://en.wikipedia.org/wiki/GUID_Partition_Table#Partition_type_GUIDs>
for a useful list of type GUIDs.

=item $g->part_set_mbr_id ($device, $partnum, $idbyte);

Sets the MBR type byte (also known as the ID byte) of
the numbered partition C<partnum> to C<idbyte>.  Note
that the type bytes quoted in most documentation are
in fact hexadecimal numbers, but usually documented
without any leading "0x" which might be confusing.

Note that only MBR (old DOS-style) partitions have type bytes.
You will get undefined results for other partition table
types (see C<$g-E<gt>part_get_parttype>).

=item $g->part_set_name ($device, $partnum, $name);

This sets the partition name on partition numbered C<partnum> on
device C<device>.  Note that partitions are numbered from 1.

The partition name can only be set on certain types of partition
table.  This works on C<gpt> but not on C<mbr> partitions.

=item $device = $g->part_to_dev ($partition);

This function takes a partition name (eg. "/dev/sdb1") and
removes the partition number, returning the device name
(eg. "/dev/sdb").

The named partition must exist, for example as a string returned
from C<$g-E<gt>list_partitions>.

See also C<$g-E<gt>part_to_partnum>, C<$g-E<gt>device_index>.

=item $partnum = $g->part_to_partnum ($partition);

This function takes a partition name (eg. "/dev/sdb1") and
returns the partition number (eg. C<1>).

The named partition must exist, for example as a string returned
from C<$g-E<gt>list_partitions>.

See also C<$g-E<gt>part_to_dev>.

=item $g->ping_daemon ();

This is a test probe into the guestfs daemon running inside
the libguestfs appliance.  Calling this function checks that the
daemon responds to the ping message, without affecting the daemon
or attached block device(s) in any other way.

=item $content = $g->pread ($path, $count, $offset);

This command lets you read part of a file.  It reads C<count>
bytes of the file, starting at C<offset>, from file C<path>.

This may read fewer bytes than requested.  For further details
see the L<pread(2)> system call.

See also C<$g-E<gt>pwrite>, C<$g-E<gt>pread_device>.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

=item $content = $g->pread_device ($device, $count, $offset);

This command lets you read part of a block device.  It reads C<count>
bytes of C<device>, starting at C<offset>.

This may read fewer bytes than requested.  For further details
see the L<pread(2)> system call.

See also C<$g-E<gt>pread>.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

=item $g->pvchange_uuid ($device);

Generate a new random UUID for the physical volume C<device>.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item $g->pvchange_uuid_all ();

Generate new random UUIDs for all physical volumes.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item $g->pvcreate ($device);

This creates an LVM physical volume on the named C<device>,
where C<device> should usually be a partition name such
as F</dev/sda1>.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item $g->pvremove ($device);

This wipes a physical volume C<device> so that LVM will no longer
recognise it.

The implementation uses the L<pvremove(8)> command which refuses to
wipe physical volumes that contain any volume groups, so you have
to remove those first.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item $g->pvresize ($device);

This resizes (expands or shrinks) an existing LVM physical
volume to match the new size of the underlying device.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item $g->pvresize_size ($device, $size);

This command is the same as C<$g-E<gt>pvresize> except that it
allows you to specify the new size (in bytes) explicitly.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item @physvols = $g->pvs ();

List all the physical volumes detected.  This is the equivalent
of the L<pvs(8)> command.

This returns a list of just the device names that contain
PVs (eg. F</dev/sda2>).

See also C<$g-E<gt>pvs_full>.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item @physvols = $g->pvs_full ();

List all the physical volumes detected.  This is the equivalent
of the L<pvs(8)> command.  The "full" version includes all fields.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item $uuid = $g->pvuuid ($device);

This command returns the UUID of the LVM PV C<device>.

=item $nbytes = $g->pwrite ($path, $content, $offset);

This command writes to part of a file.  It writes the data
buffer C<content> to the file C<path> starting at offset C<offset>.

This command implements the L<pwrite(2)> system call, and like
that system call it may not write the full data requested.  The
return value is the number of bytes that were actually written
to the file.  This could even be 0, although short writes are
unlikely for regular files in ordinary circumstances.

See also C<$g-E<gt>pread>, C<$g-E<gt>pwrite_device>.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

=item $nbytes = $g->pwrite_device ($device, $content, $offset);

This command writes to part of a device.  It writes the data
buffer C<content> to C<device> starting at offset C<offset>.

This command implements the L<pwrite(2)> system call, and like
that system call it may not write the full data requested
(although short writes to disk devices and partitions are
probably impossible with standard Linux kernels).

See also C<$g-E<gt>pwrite>.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

=item $content = $g->read_file ($path);

This calls returns the contents of the file C<path> as a
buffer.

Unlike C<$g-E<gt>cat>, this function can correctly
handle files that contain embedded ASCII NUL characters.

=item @lines = $g->read_lines ($path);

Return the contents of the file named C<path>.

The file contents are returned as a list of lines.  Trailing
C<LF> and C<CRLF> character sequences are I<not> returned.

Note that this function cannot correctly handle binary files
(specifically, files containing C<\0> character which is treated
as end of string).  For those you need to use the C<$g-E<gt>read_file>
function and split the buffer into lines yourself.

=item @entries = $g->readdir ($dir);

This returns the list of directory entries in directory C<dir>.

All entries in the directory are returned, including C<.> and
C<..>.  The entries are I<not> sorted, but returned in the same
order as the underlying filesystem.

Also this call returns basic file type information about each
file.  The C<ftyp> field will contain one of the following characters:

=over 4

=item 'b'

Block special

=item 'c'

Char special

=item 'd'

Directory

=item 'f'

FIFO (named pipe)

=item 'l'

Symbolic link

=item 'r'

Regular file

=item 's'

Socket

=item 'u'

Unknown file type

=item '?'

The L<readdir(3)> call returned a C<d_type> field with an
unexpected value

=back

This function is primarily intended for use by programs.  To
get a simple list of names, use C<$g-E<gt>ls>.  To get a printable
directory for human consumption, use C<$g-E<gt>ll>.

=item $link = $g->readlink ($path);

This command reads the target of a symbolic link.

=item @links = $g->readlinklist ($path, \@names);

This call allows you to do a C<readlink> operation
on multiple files, where all files are in the directory C<path>.
C<names> is the list of files from this directory.

On return you get a list of strings, with a one-to-one
correspondence to the C<names> list.  Each string is the
value of the symbolic link.

If the L<readlink(2)> operation fails on any name, then
the corresponding result string is the empty string C<"">.
However the whole operation is completed even if there
were L<readlink(2)> errors, and so you can call this
function with names where you don't know if they are
symbolic links already (albeit slightly less efficient).

This call is intended for programs that want to efficiently
list a directory contents without making many round-trips.

=item $rpath = $g->realpath ($path);

Return the canonicalized absolute pathname of C<path>.  The
returned path has no C<.>, C<..> or symbolic link path elements.

=item $g->remount ($mountpoint [, rw => $rw]);

This call allows you to change the C<rw> (readonly/read-write)
flag on an already mounted filesystem at C<mountpoint>,
converting a readonly filesystem to be read-write, or vice-versa.

Note that at the moment you must supply the "optional" C<rw>
parameter.  In future we may allow other flags to be adjusted.

=item $g->remove_drive ($label);

This call does nothing and returns an error.

I<This function is deprecated.>
There is no replacement.  Consult the API documentation in
L<guestfs(3)> for further information.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->removexattr ($xattr, $path);

This call removes the extended attribute named C<xattr>
of the file C<path>.

See also: C<$g-E<gt>lremovexattr>, L<attr(5)>.

This function depends on the feature C<linuxxattrs>.  See also
C<$g-E<gt>feature-available>.

=item $g->rename ($oldpath, $newpath);

Rename a file to a new place on the same filesystem.  This is
the same as the Linux L<rename(2)> system call.  In most cases
you are better to use C<$g-E<gt>mv> instead.

=item $g->resize2fs ($device);

This resizes an ext2, ext3 or ext4 filesystem to match the size of
the underlying device.

See also L<guestfs(3)/RESIZE2FS ERRORS>.

=item $g->resize2fs_M ($device);

This command is the same as C<$g-E<gt>resize2fs>, but the filesystem
is resized to its minimum size.  This works like the I<-M> option
to the L<resize2fs(8)> command.

To get the resulting size of the filesystem you should call
C<$g-E<gt>tune2fs_l> and read the C<Block size> and C<Block count>
values.  These two numbers, multiplied together, give the
resulting size of the minimal filesystem in bytes.

See also L<guestfs(3)/RESIZE2FS ERRORS>.

=item $g->resize2fs_size ($device, $size);

This command is the same as C<$g-E<gt>resize2fs> except that it
allows you to specify the new size (in bytes) explicitly.

See also L<guestfs(3)/RESIZE2FS ERRORS>.

=item $g->rm ($path);

Remove the single file C<path>.

=item $g->rm_f ($path);

Remove the file C<path>.

If the file doesn't exist, that error is ignored.  (Other errors,
eg. I/O errors or bad paths, are not ignored)

This call cannot remove directories.
Use C<$g-E<gt>rmdir> to remove an empty directory,
or C<$g-E<gt>rm_rf> to remove directories recursively.

=item $g->rm_rf ($path);

Remove the file or directory C<path>, recursively removing the
contents if its a directory.  This is like the C<rm -rf> shell
command.

=item $g->rmdir ($path);

Remove the single directory C<path>.

=item $g->rmmountpoint ($exemptpath);

This call removes a mountpoint that was previously created
with C<$g-E<gt>mkmountpoint>.  See C<$g-E<gt>mkmountpoint>
for full details.

=item $g->rsync ($src, $dest [, archive => $archive] [, deletedest => $deletedest]);

This call may be used to copy or synchronize two directories
under the same libguestfs handle.  This uses the L<rsync(1)>
program which uses a fast algorithm that avoids copying files
unnecessarily.

C<src> and C<dest> are the source and destination directories.
Files are copied from C<src> to C<dest>.

The optional arguments are:

=over 4

=item C<archive>

Turns on archive mode.  This is the same as passing the
I<--archive> flag to C<rsync>.

=item C<deletedest>

Delete files at the destination that do not exist at the source.

=back

This function depends on the feature C<rsync>.  See also
C<$g-E<gt>feature-available>.

=item $g->rsync_in ($remote, $dest [, archive => $archive] [, deletedest => $deletedest]);

This call may be used to copy or synchronize the filesystem
on the host or on a remote computer with the filesystem
within libguestfs.  This uses the L<rsync(1)> program
which uses a fast algorithm that avoids copying files unnecessarily.

This call only works if the network is enabled.  See
C<$g-E<gt>set_network> or the I<--network> option to
various tools like L<guestfish(1)>.

Files are copied from the remote server and directory
specified by C<remote> to the destination directory C<dest>.

The format of the remote server string is defined by L<rsync(1)>.
Note that there is no way to supply a password or passphrase
so the target must be set up not to require one.

The optional arguments are the same as those of C<$g-E<gt>rsync>.

This function depends on the feature C<rsync>.  See also
C<$g-E<gt>feature-available>.

=item $g->rsync_out ($src, $remote [, archive => $archive] [, deletedest => $deletedest]);

This call may be used to copy or synchronize the filesystem within
libguestfs with a filesystem on the host or on a remote computer.
This uses the L<rsync(1)> program which uses a fast algorithm that
avoids copying files unnecessarily.

This call only works if the network is enabled.  See
C<$g-E<gt>set_network> or the I<--network> option to
various tools like L<guestfish(1)>.

Files are copied from the source directory C<src> to the
remote server and directory specified by C<remote>.

The format of the remote server string is defined by L<rsync(1)>.
Note that there is no way to supply a password or passphrase
so the target must be set up not to require one.

The optional arguments are the same as those of C<$g-E<gt>rsync>.

Globbing does not happen on the C<src> parameter.  In programs
which use the API directly you have to expand wildcards yourself
(see C<$g-E<gt>glob_expand>).  In guestfish you can use the C<glob>
command (see L<guestfish(1)/glob>), for example:

 ><fs> glob rsync-out /* rsync://remote/

This function depends on the feature C<rsync>.  See also
C<$g-E<gt>feature-available>.

=item $g->scrub_device ($device);

This command writes patterns over C<device> to make data retrieval
more difficult.

It is an interface to the L<scrub(1)> program.  See that
manual page for more details.

This function depends on the feature C<scrub>.  See also
C<$g-E<gt>feature-available>.

=item $g->scrub_file ($file);

This command writes patterns over a file to make data retrieval
more difficult.

The file is I<removed> after scrubbing.

It is an interface to the L<scrub(1)> program.  See that
manual page for more details.

This function depends on the feature C<scrub>.  See also
C<$g-E<gt>feature-available>.

=item $g->scrub_freespace ($dir);

This command creates the directory C<dir> and then fills it
with files until the filesystem is full, and scrubs the files
as for C<$g-E<gt>scrub_file>, and deletes them.
The intention is to scrub any free space on the partition
containing C<dir>.

It is an interface to the L<scrub(1)> program.  See that
manual page for more details.

This function depends on the feature C<scrub>.  See also
C<$g-E<gt>feature-available>.

=item $g->selinux_relabel ($specfile, $path [, force => $force]);

SELinux relabel parts of the filesystem.

The C<specfile> parameter controls the policy spec file used.
You have to parse C</etc/selinux/config> to find the correct
SELinux policy and then pass the spec file, usually:
C</etc/selinux/> + I<selinuxtype> + C</contexts/files/file_contexts>.

The required C<path> parameter is the top level directory where
relabelling starts.  Normally you should pass C<path> as C</>
to relabel the whole guest filesystem.

The optional C<force> boolean controls whether the context
is reset for customizable files, and also whether the
user, role and range parts of the file context is changed.

This function depends on the feature C<selinuxrelabel>.  See also
C<$g-E<gt>feature-available>.

=item $g->set_append ($append);

This function is used to add additional options to the
libguestfs appliance kernel command line.

The default is C<NULL> unless overridden by setting
C<LIBGUESTFS_APPEND> environment variable.

Setting C<append> to C<NULL> means I<no> additional options
are passed (libguestfs always adds a few of its own).

=item $g->set_attach_method ($backend);

Set the method that libguestfs uses to connect to the backend
guestfsd daemon.

See L<guestfs(3)/BACKEND>.

I<This function is deprecated.>
In new code, use the L</set_backend> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->set_autosync ($autosync);

If C<autosync> is true, this enables autosync.  Libguestfs will make a
best effort attempt to make filesystems consistent and synchronized
when the handle is closed
(also if the program exits without closing handles).

This is enabled by default (since libguestfs 1.5.24, previously it was
disabled by default).

=item $g->set_backend ($backend);

Set the method that libguestfs uses to connect to the backend
guestfsd daemon.

This handle property was previously called the "attach method".

See L<guestfs(3)/BACKEND>.

=item $g->set_backend_setting ($name, $val);

Append C<"name=value"> to the backend settings string list.
However if a string already exists matching C<"name">
or beginning with C<"name=">, then that setting is replaced.

See L<guestfs(3)/BACKEND>, L<guestfs(3)/BACKEND SETTINGS>.

=item $g->set_backend_settings (\@settings);

Set a list of zero or more settings which are passed through to
the current backend.  Each setting is a string which is interpreted
in a backend-specific way, or ignored if not understood by the
backend.

The default value is an empty list, unless the environment
variable C<LIBGUESTFS_BACKEND_SETTINGS> was set when the handle
was created.  This environment variable contains a colon-separated
list of settings.

This call replaces all backend settings.  If you want to replace
a single backend setting, see C<$g-E<gt>set_backend_setting>.
If you want to clear a single backend setting, see
C<$g-E<gt>clear_backend_setting>.

See L<guestfs(3)/BACKEND>, L<guestfs(3)/BACKEND SETTINGS>.

=item $g->set_cachedir ($cachedir);

Set the directory used by the handle to store the appliance
cache, when using a supermin appliance.  The appliance is
cached and shared between all handles which have the same
effective user ID.

The environment variables C<LIBGUESTFS_CACHEDIR> and C<TMPDIR>
control the default value: If C<LIBGUESTFS_CACHEDIR> is set, then
that is the default.  Else if C<TMPDIR> is set, then that is
the default.  Else F</var/tmp> is the default.

=item $g->set_direct ($direct);

If the direct appliance mode flag is enabled, then stdin and
stdout are passed directly through to the appliance once it
is launched.

One consequence of this is that log messages aren't caught
by the library and handled by C<$g-E<gt>set_log_message_callback>,
but go straight to stdout.

You probably don't want to use this unless you know what you
are doing.

The default is disabled.

I<This function is deprecated.>
In new code, use the L</internal_get_console_socket> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->set_e2attrs ($file, $attrs [, clear => $clear]);

This sets or clears the file attributes C<attrs>
associated with the inode F<file>.

C<attrs> is a string of characters representing
file attributes.  See C<$g-E<gt>get_e2attrs> for a list of
possible attributes.  Not all attributes can be changed.

If optional boolean C<clear> is not present or false, then
the C<attrs> listed are set in the inode.

If C<clear> is true, then the C<attrs> listed are cleared
in the inode.

In both cases, other attributes not present in the C<attrs>
string are left unchanged.

These attributes are only present when the file is located on
an ext2/3/4 filesystem.  Using this call on other filesystem
types will result in an error.

=item $g->set_e2generation ($file, $generation);

This sets the ext2 file generation of a file.

See C<$g-E<gt>get_e2generation>.

=item $g->set_e2label ($device, $label);

This sets the ext2/3/4 filesystem label of the filesystem on
C<device> to C<label>.  Filesystem labels are limited to
16 characters.

You can use either C<$g-E<gt>tune2fs_l> or C<$g-E<gt>get_e2label>
to return the existing label on a filesystem.

I<This function is deprecated.>
In new code, use the L</set_label> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->set_e2uuid ($device, $uuid);

This sets the ext2/3/4 filesystem UUID of the filesystem on
C<device> to C<uuid>.  The format of the UUID and alternatives
such as C<clear>, C<random> and C<time> are described in the
L<tune2fs(8)> manpage.

You can use C<$g-E<gt>vfs_uuid> to return the existing UUID
of a filesystem.

I<This function is deprecated.>
In new code, use the L</set_uuid> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->set_hv ($hv);

Set the hypervisor binary that we will use.  The hypervisor
depends on the backend, but is usually the location of the
qemu/KVM hypervisor.

The default is chosen when the library was compiled by the
configure script.

You can also override this by setting the C<LIBGUESTFS_HV>
environment variable.

Note that you should call this function as early as possible
after creating the handle.  This is because some pre-launch
operations depend on testing qemu features (by running C<qemu -help>).
If the qemu binary changes, we don't retest features, and
so you might see inconsistent results.  Using the environment
variable C<LIBGUESTFS_HV> is safest of all since that picks
the qemu binary at the same time as the handle is created.

=item $g->set_identifier ($identifier);

This is an informative string which the caller may optionally
set in the handle.  It is printed in various places, allowing
the current handle to be identified in debugging output.

One important place is when tracing is enabled.  If the
identifier string is not an empty string, then trace messages
change from this:

 libguestfs: trace: get_tmpdir
 libguestfs: trace: get_tmpdir = "/tmp"

to this:

 libguestfs: trace: ID: get_tmpdir
 libguestfs: trace: ID: get_tmpdir = "/tmp"

where C<ID> is the identifier string set by this call.

The identifier must only contain alphanumeric ASCII characters,
underscore and minus sign.  The default is the empty string.

See also C<$g-E<gt>set_program>, C<$g-E<gt>set_trace>,
C<$g-E<gt>get_identifier>.

=item $g->set_label ($mountable, $label);

Set the filesystem label on C<mountable> to C<label>.

Only some filesystem types support labels, and libguestfs supports
setting labels on only a subset of these.

=over 4

=item ext2, ext3, ext4

Labels are limited to 16 bytes.

=item NTFS

Labels are limited to 128 unicode characters.

=item XFS

The label is limited to 12 bytes.  The filesystem must not
be mounted when trying to set the label.

=item btrfs

The label is limited to 255 bytes and some characters are
not allowed.  Setting the label on a btrfs subvolume will set the
label on its parent filesystem.  The filesystem must not be mounted
when trying to set the label.

=item fat

The label is limited to 11 bytes.

=item swap

The label is limited to 16 bytes.

=back

If there is no support for changing the label
for the type of the specified filesystem,
set_label will fail and set errno as ENOTSUP.

To read the label on a filesystem, call C<$g-E<gt>vfs_label>.

=item $g->set_libvirt_requested_credential ($index, $cred);

After requesting the C<index>'th credential from the user,
call this function to pass the answer back to libvirt.

See L<guestfs(3)/LIBVIRT AUTHENTICATION> for documentation and example code.

=item $g->set_libvirt_supported_credentials (\@creds);

Call this function before setting an event handler for
C<GUESTFS_EVENT_LIBVIRT_AUTH>, to supply the list of credential types
that the program knows how to process.

The C<creds> list must be a non-empty list of strings.
Possible strings are:

=over 4

=item C<username>

=item C<authname>

=item C<language>

=item C<cnonce>

=item C<passphrase>

=item C<echoprompt>

=item C<noechoprompt>

=item C<realm>

=item C<external>

=back

See libvirt documentation for the meaning of these credential types.

See L<guestfs(3)/LIBVIRT AUTHENTICATION> for documentation and example code.

=item $g->set_memsize ($memsize);

This sets the memory size in megabytes allocated to the
hypervisor.  This only has any effect if called before
C<$g-E<gt>launch>.

You can also change this by setting the environment
variable C<LIBGUESTFS_MEMSIZE> before the handle is
created.

For more information on the architecture of libguestfs,
see L<guestfs(3)>.

=item $g->set_network ($network);

If C<network> is true, then the network is enabled in the
libguestfs appliance.  The default is false.

This affects whether commands are able to access the network
(see L<guestfs(3)/RUNNING COMMANDS>).

You must call this before calling C<$g-E<gt>launch>, otherwise
it has no effect.

=item $g->set_path ($searchpath);

Set the path that libguestfs searches for kernel and initrd.img.

The default is C<$libdir/guestfs> unless overridden by setting
C<LIBGUESTFS_PATH> environment variable.

Setting C<path> to C<NULL> restores the default path.

=item $g->set_pgroup ($pgroup);

If C<pgroup> is true, child processes are placed into
their own process group.

The practical upshot of this is that signals like C<SIGINT> (from
users pressing C<^C>) won't be received by the child process.

The default for this flag is false, because usually you want
C<^C> to kill the subprocess.  Guestfish sets this flag to
true when used interactively, so that C<^C> can cancel
long-running commands gracefully (see C<$g-E<gt>user_cancel>).

=item $g->set_program ($program);

Set the program name.  This is an informative string which the
main program may optionally set in the handle.

When the handle is created, the program name in the handle is
set to the basename from C<argv[0]>.  The program name can never
be C<NULL>.

=item $g->set_qemu ($hv);

Set the hypervisor binary (usually qemu) that we will use.

The default is chosen when the library was compiled by the
configure script.

You can also override this by setting the C<LIBGUESTFS_HV>
environment variable.

Setting C<hv> to C<NULL> restores the default qemu binary.

Note that you should call this function as early as possible
after creating the handle.  This is because some pre-launch
operations depend on testing qemu features (by running C<qemu -help>).
If the qemu binary changes, we don't retest features, and
so you might see inconsistent results.  Using the environment
variable C<LIBGUESTFS_HV> is safest of all since that picks
the qemu binary at the same time as the handle is created.

I<This function is deprecated.>
In new code, use the L</set_hv> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->set_recovery_proc ($recoveryproc);

If this is called with the parameter C<false> then
C<$g-E<gt>launch> does not create a recovery process.  The
purpose of the recovery process is to stop runaway hypervisor
processes in the case where the main program aborts abruptly.

This only has any effect if called before C<$g-E<gt>launch>,
and the default is true.

About the only time when you would want to disable this is
if the main process will fork itself into the background
("daemonize" itself).  In this case the recovery process
thinks that the main program has disappeared and so kills
the hypervisor, which is not very helpful.

=item $g->set_selinux ($selinux);

This sets the selinux flag that is passed to the appliance
at boot time.  The default is C<selinux=0> (disabled).

Note that if SELinux is enabled, it is always in
Permissive mode (C<enforcing=0>).

For more information on the architecture of libguestfs,
see L<guestfs(3)>.

I<This function is deprecated.>
In new code, use the L</selinux_relabel> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->set_smp ($smp);

Change the number of virtual CPUs assigned to the appliance.  The
default is C<1>.  Increasing this may improve performance, though
often it has no effect.

This function must be called before C<$g-E<gt>launch>.

=item $g->set_tmpdir ($tmpdir);

Set the directory used by the handle to store temporary files.

The environment variables C<LIBGUESTFS_TMPDIR> and C<TMPDIR>
control the default value: If C<LIBGUESTFS_TMPDIR> is set, then
that is the default.  Else if C<TMPDIR> is set, then that is
the default.  Else F</tmp> is the default.

=item $g->set_trace ($trace);

If the command trace flag is set to 1, then libguestfs
calls, parameters and return values are traced.

If you want to trace C API calls into libguestfs (and
other libraries) then possibly a better way is to use
the external L<ltrace(1)> command.

Command traces are disabled unless the environment variable
C<LIBGUESTFS_TRACE> is defined and set to C<1>.

Trace messages are normally sent to C<stderr>, unless you
register a callback to send them somewhere else (see
C<$g-E<gt>set_event_callback>).

=item $g->set_uuid ($device, $uuid);

Set the filesystem UUID on C<device> to C<uuid>.
If this fails and the errno is ENOTSUP,
means that there is no support for changing the UUID
for the type of the specified filesystem.

Only some filesystem types support setting UUIDs.

To read the UUID on a filesystem, call C<$g-E<gt>vfs_uuid>.

=item $g->set_uuid_random ($device);

Set the filesystem UUID on C<device> to a random UUID.
If this fails and the errno is ENOTSUP,
means that there is no support for changing the UUID
for the type of the specified filesystem.

Only some filesystem types support setting UUIDs.

To read the UUID on a filesystem, call C<$g-E<gt>vfs_uuid>.

=item $g->set_verbose ($verbose);

If C<verbose> is true, this turns on verbose messages.

Verbose messages are disabled unless the environment variable
C<LIBGUESTFS_DEBUG> is defined and set to C<1>.

Verbose messages are normally sent to C<stderr>, unless you
register a callback to send them somewhere else (see
C<$g-E<gt>set_event_callback>).

=item $g->setcon ($context);

This sets the SELinux security context of the daemon
to the string C<context>.

See the documentation about SELINUX in L<guestfs(3)>.

This function depends on the feature C<selinux>.  See also
C<$g-E<gt>feature-available>.

I<This function is deprecated.>
In new code, use the L</selinux_relabel> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->setxattr ($xattr, $val, $vallen, $path);

This call sets the extended attribute named C<xattr>
of the file C<path> to the value C<val> (of length C<vallen>).
The value is arbitrary 8 bit data.

See also: C<$g-E<gt>lsetxattr>, L<attr(5)>.

This function depends on the feature C<linuxxattrs>.  See also
C<$g-E<gt>feature-available>.

=item $g->sfdisk ($device, $cyls, $heads, $sectors, \@lines);

This is a direct interface to the L<sfdisk(8)> program for creating
partitions on block devices.

C<device> should be a block device, for example F</dev/sda>.

C<cyls>, C<heads> and C<sectors> are the number of cylinders, heads
and sectors on the device, which are passed directly to L<sfdisk(8)>
as the I<-C>, I<-H> and I<-S> parameters.  If you pass C<0> for any
of these, then the corresponding parameter is omitted.  Usually for
‘large’ disks, you can just pass C<0> for these, but for small
(floppy-sized) disks, L<sfdisk(8)> (or rather, the kernel) cannot work
out the right geometry and you will need to tell it.

C<lines> is a list of lines that we feed to L<sfdisk(8)>.  For more
information refer to the L<sfdisk(8)> manpage.

To create a single partition occupying the whole disk, you would
pass C<lines> as a single element list, when the single element being
the string C<,> (comma).

See also: C<$g-E<gt>sfdisk_l>, C<$g-E<gt>sfdisk_N>,
C<$g-E<gt>part_init>

I<This function is deprecated.>
In new code, use the L</part_add> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->sfdiskM ($device, \@lines);

This is a simplified interface to the C<$g-E<gt>sfdisk>
command, where partition sizes are specified in megabytes
only (rounded to the nearest cylinder) and you don't need
to specify the cyls, heads and sectors parameters which
were rarely if ever used anyway.

See also: C<$g-E<gt>sfdisk>, the L<sfdisk(8)> manpage
and C<$g-E<gt>part_disk>

I<This function is deprecated.>
In new code, use the L</part_add> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->sfdisk_N ($device, $partnum, $cyls, $heads, $sectors, $line);

This runs L<sfdisk(8)> option to modify just the single
partition C<n> (note: C<n> counts from 1).

For other parameters, see C<$g-E<gt>sfdisk>.  You should usually
pass C<0> for the cyls/heads/sectors parameters.

See also: C<$g-E<gt>part_add>

I<This function is deprecated.>
In new code, use the L</part_add> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $partitions = $g->sfdisk_disk_geometry ($device);

This displays the disk geometry of C<device> read from the
partition table.  Especially in the case where the underlying
block device has been resized, this can be different from the
kernel’s idea of the geometry (see C<$g-E<gt>sfdisk_kernel_geometry>).

The result is in human-readable format, and not designed to
be parsed.

=item $partitions = $g->sfdisk_kernel_geometry ($device);

This displays the kernel’s idea of the geometry of C<device>.

The result is in human-readable format, and not designed to
be parsed.

=item $partitions = $g->sfdisk_l ($device);

This displays the partition table on C<device>, in the
human-readable output of the L<sfdisk(8)> command.  It is
not intended to be parsed.

See also: C<$g-E<gt>part_list>

I<This function is deprecated.>
In new code, use the L</part_list> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $output = $g->sh ($command);

This call runs a command from the guest filesystem via the
guest’s F</bin/sh>.

This is like C<$g-E<gt>command>, but passes the command to:

 /bin/sh -c "command"

Depending on the guest’s shell, this usually results in
wildcards being expanded, shell expressions being interpolated
and so on.

All the provisos about C<$g-E<gt>command> apply to this call.

=item @lines = $g->sh_lines ($command);

This is the same as C<$g-E<gt>sh>, but splits the result
into a list of lines.

See also: C<$g-E<gt>command_lines>

=item $g->shutdown ();

This is the opposite of C<$g-E<gt>launch>.  It performs an orderly
shutdown of the backend process(es).  If the autosync flag is set
(which is the default) then the disk image is synchronized.

If the subprocess exits with an error then this function will return
an error, which should I<not> be ignored (it may indicate that the
disk image could not be written out properly).

It is safe to call this multiple times.  Extra calls are ignored.

This call does I<not> close or free up the handle.  You still
need to call C<$g-E<gt>close> afterwards.

C<$g-E<gt>close> will call this if you don't do it explicitly,
but note that any errors are ignored in that case.

=item $g->sleep ($secs);

Sleep for C<secs> seconds.

=item %statbuf = $g->stat ($path);

Returns file information for the given C<path>.

This is the same as the L<stat(2)> system call.

I<This function is deprecated.>
In new code, use the L</statns> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item %statbuf = $g->statns ($path);

Returns file information for the given C<path>.

This is the same as the L<stat(2)> system call.

=item %statbuf = $g->statvfs ($path);

Returns file system statistics for any mounted file system.
C<path> should be a file or directory in the mounted file system
(typically it is the mount point itself, but it doesn't need to be).

This is the same as the L<statvfs(2)> system call.

=item @stringsout = $g->strings ($path);

This runs the L<strings(1)> command on a file and returns
the list of printable strings found.

The C<strings> command has, in the past, had problems with
parsing untrusted files.  These are mitigated in the current
version of libguestfs, but see L<guestfs(3)/CVE-2014-8484>.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

=item @stringsout = $g->strings_e ($encoding, $path);

This is like the C<$g-E<gt>strings> command, but allows you to
specify the encoding of strings that are looked for in
the source file C<path>.

Allowed encodings are:

=over 4

=item s

Single 7-bit-byte characters like ASCII and the ASCII-compatible
parts of ISO-8859-X (this is what C<$g-E<gt>strings> uses).

=item S

Single 8-bit-byte characters.

=item b

16-bit big endian strings such as those encoded in
UTF-16BE or UCS-2BE.

=item l (lower case letter L)

16-bit little endian such as UTF-16LE and UCS-2LE.
This is useful for examining binaries in Windows guests.

=item B

32-bit big endian such as UCS-4BE.

=item L

32-bit little endian such as UCS-4LE.

=back

The returned strings are transcoded to UTF-8.

The C<strings> command has, in the past, had problems with
parsing untrusted files.  These are mitigated in the current
version of libguestfs, but see L<guestfs(3)/CVE-2014-8484>.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

=item $g->swapoff_device ($device);

This command disables the libguestfs appliance swap
device or partition named C<device>.
See C<$g-E<gt>swapon_device>.

=item $g->swapoff_file ($file);

This command disables the libguestfs appliance swap on file.

=item $g->swapoff_label ($label);

This command disables the libguestfs appliance swap on
labeled swap partition.

=item $g->swapoff_uuid ($uuid);

This command disables the libguestfs appliance swap partition
with the given UUID.

This function depends on the feature C<linuxfsuuid>.  See also
C<$g-E<gt>feature-available>.

=item $g->swapon_device ($device);

This command enables the libguestfs appliance to use the
swap device or partition named C<device>.  The increased
memory is made available for all commands, for example
those run using C<$g-E<gt>command> or C<$g-E<gt>sh>.

Note that you should not swap to existing guest swap
partitions unless you know what you are doing.  They may
contain hibernation information, or other information that
the guest doesn't want you to trash.  You also risk leaking
information about the host to the guest this way.  Instead,
attach a new host device to the guest and swap on that.

=item $g->swapon_file ($file);

This command enables swap to a file.
See C<$g-E<gt>swapon_device> for other notes.

=item $g->swapon_label ($label);

This command enables swap to a labeled swap partition.
See C<$g-E<gt>swapon_device> for other notes.

=item $g->swapon_uuid ($uuid);

This command enables swap to a swap partition with the given UUID.
See C<$g-E<gt>swapon_device> for other notes.

This function depends on the feature C<linuxfsuuid>.  See also
C<$g-E<gt>feature-available>.

=item $g->sync ();

This syncs the disk, so that any writes are flushed through to the
underlying disk image.

You should always call this if you have modified a disk image, before
closing the handle.

=item $g->syslinux ($device [, directory => $directory]);

Install the SYSLINUX bootloader on C<device>.

The device parameter must be either a whole disk formatted
as a FAT filesystem, or a partition formatted as a FAT filesystem.
In the latter case, the partition should be marked as "active"
(C<$g-E<gt>part_set_bootable>) and a Master Boot Record must be
installed (eg. using C<$g-E<gt>pwrite_device>) on the first
sector of the whole disk.
The SYSLINUX package comes with some suitable Master Boot Records.
See the L<syslinux(1)> man page for further information.

The optional arguments are:

=over 4

=item F<directory>

Install SYSLINUX in the named subdirectory, instead of in the
root directory of the FAT filesystem.

=back

Additional configuration can be supplied to SYSLINUX by
placing a file called F<syslinux.cfg> on the FAT filesystem,
either in the root directory, or under F<directory> if that
optional argument is being used.  For further information
about the contents of this file, see L<syslinux(1)>.

See also C<$g-E<gt>extlinux>.

This function depends on the feature C<syslinux>.  See also
C<$g-E<gt>feature-available>.

=item @lines = $g->tail ($path);

This command returns up to the last 10 lines of a file as
a list of strings.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

=item @lines = $g->tail_n ($nrlines, $path);

If the parameter C<nrlines> is a positive number, this returns the last
C<nrlines> lines of the file C<path>.

If the parameter C<nrlines> is a negative number, this returns lines
from the file C<path>, starting with the C<-nrlines>'th line.

If the parameter C<nrlines> is zero, this returns an empty list.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

=item $g->tar_in ($tarfile, $directory [, compress => $compress] [, xattrs => $xattrs] [, selinux => $selinux] [, acls => $acls]);

This command uploads and unpacks local file C<tarfile> into F<directory>.

The optional C<compress> flag controls compression.  If not given,
then the input should be an uncompressed tar file.  Otherwise one
of the following strings may be given to select the compression
type of the input file: C<compress>, C<gzip>, C<bzip2>, C<xz>, C<lzop>,
C<lzma>, C<zstd>.  (Note that not all builds of libguestfs will support
all of these compression types).

The other optional arguments are:

=over 4

=item C<xattrs>

If set to true, extended attributes are restored from the tar file.

=item C<selinux>

If set to true, SELinux contexts are restored from the tar file.

=item C<acls>

If set to true, POSIX ACLs are restored from the tar file.

=back

=item $g->tar_in_opts ($tarfile, $directory [, compress => $compress] [, xattrs => $xattrs] [, selinux => $selinux] [, acls => $acls]);

This is an alias of L</tar_in>.

=cut

sub tar_in_opts {
  &tar_in (@_)
}

=pod

=item $g->tar_out ($directory, $tarfile [, compress => $compress] [, numericowner => $numericowner] [, excludes => $excludes] [, xattrs => $xattrs] [, selinux => $selinux] [, acls => $acls]);

This command packs the contents of F<directory> and downloads
it to local file C<tarfile>.

The optional C<compress> flag controls compression.  If not given,
then the output will be an uncompressed tar file.  Otherwise one
of the following strings may be given to select the compression
type of the output file: C<compress>, C<gzip>, C<bzip2>, C<xz>, C<lzop>,
C<lzma>, C<zstd>.  (Note that not all builds of libguestfs will support
all of these compression types).

The other optional arguments are:

=over 4

=item C<excludes>

A list of wildcards.  Files are excluded if they match any of the
wildcards.

=item C<numericowner>

If set to true, the output tar file will contain UID/GID numbers
instead of user/group names.

=item C<xattrs>

If set to true, extended attributes are saved in the output tar.

=item C<selinux>

If set to true, SELinux contexts are saved in the output tar.

=item C<acls>

If set to true, POSIX ACLs are saved in the output tar.

=back

=item $g->tar_out_opts ($directory, $tarfile [, compress => $compress] [, numericowner => $numericowner] [, excludes => $excludes] [, xattrs => $xattrs] [, selinux => $selinux] [, acls => $acls]);

This is an alias of L</tar_out>.

=cut

sub tar_out_opts {
  &tar_out (@_)
}

=pod

=item $g->tgz_in ($tarball, $directory);

This command uploads and unpacks local file C<tarball> (a
I<gzip compressed> tar file) into F<directory>.

I<This function is deprecated.>
In new code, use the L</tar_in> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->tgz_out ($directory, $tarball);

This command packs the contents of F<directory> and downloads
it to local file C<tarball>.

I<This function is deprecated.>
In new code, use the L</tar_out> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->touch ($path);

Touch acts like the L<touch(1)> command.  It can be used to
update the timestamps on a file, or, if the file does not exist,
to create a new zero-length file.

This command only works on regular files, and will fail on other
file types such as directories, symbolic links, block special etc.

=item $g->truncate ($path);

This command truncates C<path> to a zero-length file.  The
file must exist already.

=item $g->truncate_size ($path, $size);

This command truncates C<path> to size C<size> bytes.  The file
must exist already.

If the current file size is less than C<size> then
the file is extended to the required size with zero bytes.
This creates a sparse file (ie. disk blocks are not allocated
for the file until you write to it).  To create a non-sparse
file of zeroes, use C<$g-E<gt>fallocate64> instead.

=item $g->tune2fs ($device [, force => $force] [, maxmountcount => $maxmountcount] [, mountcount => $mountcount] [, errorbehavior => $errorbehavior] [, group => $group] [, intervalbetweenchecks => $intervalbetweenchecks] [, reservedblockspercentage => $reservedblockspercentage] [, lastmounteddirectory => $lastmounteddirectory] [, reservedblockscount => $reservedblockscount] [, user => $user]);

This call allows you to adjust various filesystem parameters of
an ext2/ext3/ext4 filesystem called C<device>.

The optional parameters are:

=over 4

=item C<force>

Force tune2fs to complete the operation even in the face of errors.
This is the same as the L<tune2fs(8)> C<-f> option.

=item C<maxmountcount>

Set the number of mounts after which the filesystem is checked
by L<e2fsck(8)>.  If this is C<0> then the number of mounts is
disregarded.  This is the same as the L<tune2fs(8)> C<-c> option.

=item C<mountcount>

Set the number of times the filesystem has been mounted.
This is the same as the L<tune2fs(8)> C<-C> option.

=item C<errorbehavior>

Change the behavior of the kernel code when errors are detected.
Possible values currently are: C<continue>, C<remount-ro>, C<panic>.
In practice these options don't really make any difference,
particularly for write errors.

This is the same as the L<tune2fs(8)> C<-e> option.

=item C<group>

Set the group which can use reserved filesystem blocks.
This is the same as the L<tune2fs(8)> C<-g> option except that it
can only be specified as a number.

=item C<intervalbetweenchecks>

Adjust the maximal time between two filesystem checks
(in seconds).  If the option is passed as C<0> then
time-dependent checking is disabled.

This is the same as the L<tune2fs(8)> C<-i> option.

=item C<reservedblockspercentage>

Set the percentage of the filesystem which may only be allocated
by privileged processes.
This is the same as the L<tune2fs(8)> C<-m> option.

=item C<lastmounteddirectory>

Set the last mounted directory.
This is the same as the L<tune2fs(8)> C<-M> option.

=item C<reservedblockscount>
Set the number of reserved filesystem blocks.
This is the same as the L<tune2fs(8)> C<-r> option.

=item C<user>

Set the user who can use the reserved filesystem blocks.
This is the same as the L<tune2fs(8)> C<-u> option except that it
can only be specified as a number.

=back

To get the current values of filesystem parameters, see
C<$g-E<gt>tune2fs_l>.  For precise details of how tune2fs
works, see the L<tune2fs(8)> man page.

=item %superblock = $g->tune2fs_l ($device);

This returns the contents of the ext2, ext3 or ext4 filesystem
superblock on C<device>.

It is the same as running C<tune2fs -l device>.  See L<tune2fs(8)>
manpage for more details.  The list of fields returned isn't
clearly defined, and depends on both the version of C<tune2fs>
that libguestfs was built against, and the filesystem itself.

=item $g->txz_in ($tarball, $directory);

This command uploads and unpacks local file C<tarball> (an
I<xz compressed> tar file) into F<directory>.

This function depends on the feature C<xz>.  See also
C<$g-E<gt>feature-available>.

I<This function is deprecated.>
In new code, use the L</tar_in> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->txz_out ($directory, $tarball);

This command packs the contents of F<directory> and downloads
it to local file C<tarball> (as an xz compressed tar archive).

This function depends on the feature C<xz>.  See also
C<$g-E<gt>feature-available>.

I<This function is deprecated.>
In new code, use the L</tar_out> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $oldmask = $g->umask ($mask);

This function sets the mask used for creating new files and
device nodes to C<mask & 0777>.

Typical umask values would be C<022> which creates new files
with permissions like "-rw-r--r--" or "-rwxr-xr-x", and
C<002> which creates new files with permissions like
"-rw-rw-r--" or "-rwxrwxr-x".

The default umask is C<022>.  This is important because it
means that directories and device nodes will be created with
C<0644> or C<0755> mode even if you specify C<0777>.

See also C<$g-E<gt>get_umask>,
L<umask(2)>, C<$g-E<gt>mknod>, C<$g-E<gt>mkdir>.

This call returns the previous umask.

=item $g->umount ($pathordevice [, force => $force] [, lazyunmount => $lazyunmount]);

This unmounts the given filesystem.  The filesystem may be
specified either by its mountpoint (path) or the device which
contains the filesystem.

=item $g->umount_opts ($pathordevice [, force => $force] [, lazyunmount => $lazyunmount]);

This is an alias of L</umount>.

=cut

sub umount_opts {
  &umount (@_)
}

=pod

=item $g->umount_all ();

This unmounts all mounted filesystems.

Some internal mounts are not unmounted by this call.

=item $g->umount_local ([retry => $retry]);

If libguestfs is exporting the filesystem on a local
mountpoint, then this unmounts it.

See L<guestfs(3)/MOUNT LOCAL> for full documentation.

=item $g->upload ($filename, $remotefilename);

Upload local file F<filename> to F<remotefilename> on the
filesystem.

F<filename> can also be a named pipe.

See also C<$g-E<gt>download>.

=item $g->upload_offset ($filename, $remotefilename, $offset);

Upload local file F<filename> to F<remotefilename> on the
filesystem.

F<remotefilename> is overwritten starting at the byte C<offset>
specified.  The intention is to overwrite parts of existing
files or devices, although if a non-existent file is specified
then it is created with a "hole" before C<offset>.  The
size of the data written is implicit in the size of the
source F<filename>.

Note that there is no limit on the amount of data that
can be uploaded with this call, unlike with C<$g-E<gt>pwrite>,
and this call always writes the full amount unless an
error occurs.

See also C<$g-E<gt>upload>, C<$g-E<gt>pwrite>.

=item $g->user_cancel ();

This function cancels the current upload or download operation.

Unlike most other libguestfs calls, this function is signal safe and
thread safe.  You can call it from a signal handler or from another
thread, without needing to do any locking.

The transfer that was in progress (if there is one) will stop shortly
afterwards, and will return an error.  The errno (see
L</guestfs_last_errno>) is set to C<EINTR>, so you can test for this
to find out if the operation was cancelled or failed because of
another error.

No cleanup is performed: for example, if a file was being uploaded
then after cancellation there may be a partially uploaded file.  It is
the caller’s responsibility to clean up if necessary.

There are two common places that you might call C<$g-E<gt>user_cancel>:

In an interactive text-based program, you might call it from a
C<SIGINT> signal handler so that pressing C<^C> cancels the current
operation.  (You also need to call C<$g-E<gt>set_pgroup> so that
child processes don't receive the C<^C> signal).

In a graphical program, when the main thread is displaying a progress
bar with a cancel button, wire up the cancel button to call this
function.

=item $g->utimens ($path, $atsecs, $atnsecs, $mtsecs, $mtnsecs);

This command sets the timestamps of a file with nanosecond
precision.

C<atsecs>, C<atnsecs> are the last access time (atime) in secs and
nanoseconds from the epoch.

C<mtsecs>, C<mtnsecs> are the last modification time (mtime) in
secs and nanoseconds from the epoch.

If the C<*nsecs> field contains the special value C<-1> then
the corresponding timestamp is set to the current time.  (The
C<*secs> field is ignored in this case).

If the C<*nsecs> field contains the special value C<-2> then
the corresponding timestamp is left unchanged.  (The
C<*secs> field is ignored in this case).

=item %uts = $g->utsname ();

This returns the kernel version of the appliance, where this is
available.  This information is only useful for debugging.  Nothing
in the returned structure is defined by the API.

=item %version = $g->version ();

Return the libguestfs version number that the program is linked
against.

Note that because of dynamic linking this is not necessarily
the version of libguestfs that you compiled against.  You can
compile the program, and then at runtime dynamically link
against a completely different F<libguestfs.so> library.

This call was added in version C<1.0.58>.  In previous
versions of libguestfs there was no way to get the version
number.  From C code you can use dynamic linker functions
to find out if this symbol exists (if it doesn't, then
it’s an earlier version).

The call returns a structure with four elements.  The first
three (C<major>, C<minor> and C<release>) are numbers and
correspond to the usual version triplet.  The fourth element
(C<extra>) is a string and is normally empty, but may be
used for distro-specific information.

To construct the original version string:
C<$major.$minor.$release$extra>

See also: L<guestfs(3)/LIBGUESTFS VERSION NUMBERS>.

I<Note:> Don't use this call to test for availability
of features.  In enterprise distributions we backport
features from later versions into earlier versions,
making this an unreliable way to test for features.
Use C<$g-E<gt>available> or C<$g-E<gt>feature_available> instead.

=item $label = $g->vfs_label ($mountable);

This returns the label of the filesystem on C<mountable>.

If the filesystem is unlabeled, this returns the empty string.

To find a filesystem from the label, use C<$g-E<gt>findfs_label>.

=item $sizeinbytes = $g->vfs_minimum_size ($mountable);

Get the minimum size of filesystem in bytes.
This is the minimum possible size for filesystem shrinking.

If getting minimum size of specified filesystem is not supported,
this will fail and set errno as ENOTSUP.

See also L<ntfsresize(8)>, L<resize2fs(8)>, L<btrfs(8)>, L<xfs_info(8)>.

=item $fstype = $g->vfs_type ($mountable);

This command gets the filesystem type corresponding to
the filesystem on C<mountable>.

For most filesystems, the result is the name of the Linux
VFS module which would be used to mount this filesystem
if you mounted it without specifying the filesystem type.
For example a string such as C<ext3> or C<ntfs>.

=item $uuid = $g->vfs_uuid ($mountable);

This returns the filesystem UUID of the filesystem on C<mountable>.

If the filesystem does not have a UUID, this returns the empty string.

To find a filesystem from the UUID, use C<$g-E<gt>findfs_uuid>.

=item $g->vg_activate ($activate, \@volgroups);

This command activates or (if C<activate> is false) deactivates
all logical volumes in the listed volume groups C<volgroups>.

This command is the same as running C<vgchange -a y|n volgroups...>

Note that if C<volgroups> is an empty list then B<all> volume groups
are activated or deactivated.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item $g->vg_activate_all ($activate);

This command activates or (if C<activate> is false) deactivates
all logical volumes in all volume groups.

This command is the same as running C<vgchange -a y|n>

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item $g->vgchange_uuid ($vg);

Generate a new random UUID for the volume group C<vg>.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item $g->vgchange_uuid_all ();

Generate new random UUIDs for all volume groups.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item $g->vgcreate ($volgroup, \@physvols);

This creates an LVM volume group called C<volgroup>
from the non-empty list of physical volumes C<physvols>.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item @uuids = $g->vglvuuids ($vgname);

Given a VG called C<vgname>, this returns the UUIDs of all
the logical volumes created in this volume group.

You can use this along with C<$g-E<gt>lvs> and C<$g-E<gt>lvuuid>
calls to associate logical volumes and volume groups.

See also C<$g-E<gt>vgpvuuids>.

=item $metadata = $g->vgmeta ($vgname);

C<vgname> is an LVM volume group.  This command examines the
volume group and returns its metadata.

Note that the metadata is an internal structure used by LVM,
subject to change at any time, and is provided for information only.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item @uuids = $g->vgpvuuids ($vgname);

Given a VG called C<vgname>, this returns the UUIDs of all
the physical volumes that this volume group resides on.

You can use this along with C<$g-E<gt>pvs> and C<$g-E<gt>pvuuid>
calls to associate physical volumes and volume groups.

See also C<$g-E<gt>vglvuuids>.

=item $g->vgremove ($vgname);

Remove an LVM volume group C<vgname>, (for example C<VG>).

This also forcibly removes all logical volumes in the volume
group (if any).

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item $g->vgrename ($volgroup, $newvolgroup);

Rename a volume group C<volgroup> with the new name C<newvolgroup>.

=item @volgroups = $g->vgs ();

List all the volumes groups detected.  This is the equivalent
of the L<vgs(8)> command.

This returns a list of just the volume group names that were
detected (eg. C<VolGroup00>).

See also C<$g-E<gt>vgs_full>.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item @volgroups = $g->vgs_full ();

List all the volumes groups detected.  This is the equivalent
of the L<vgs(8)> command.  The "full" version includes all fields.

This function depends on the feature C<lvm2>.  See also
C<$g-E<gt>feature-available>.

=item $g->vgscan ();

This rescans all block devices and rebuilds the list of LVM
physical volumes, volume groups and logical volumes.

I<This function is deprecated.>
In new code, use the L</lvm_scan> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $uuid = $g->vguuid ($vgname);

This command returns the UUID of the LVM VG named C<vgname>.

=item $g->wait_ready ();

This function is a no op.

In versions of the API E<lt> 1.0.71 you had to call this function
just after calling C<$g-E<gt>launch> to wait for the launch
to complete.  However this is no longer necessary because
C<$g-E<gt>launch> now does the waiting.

If you see any calls to this function in code then you can just
remove them, unless you want to retain compatibility with older
versions of the API.

I<This function is deprecated.>
There is no replacement.  Consult the API documentation in
L<guestfs(3)> for further information.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $chars = $g->wc_c ($path);

This command counts the characters in a file, using the
C<wc -c> external command.

=item $lines = $g->wc_l ($path);

This command counts the lines in a file, using the
C<wc -l> external command.

=item $words = $g->wc_w ($path);

This command counts the words in a file, using the
C<wc -w> external command.

=item $g->wipefs ($device);

This command erases filesystem or RAID signatures from
the specified C<device> to make the filesystem invisible to libblkid.

This does not erase the filesystem itself nor any other data from the
C<device>.

Compare with C<$g-E<gt>zero> which zeroes the first few blocks of a
device.

This function depends on the feature C<wipefs>.  See also
C<$g-E<gt>feature-available>.

=item $g->write ($path, $content);

This call creates a file called C<path>.  The content of the
file is the string C<content> (which can contain any 8 bit data).

See also C<$g-E<gt>write_append>.

=item $g->write_append ($path, $content);

This call appends C<content> to the end of file C<path>.  If
C<path> does not exist, then a new file is created.

See also C<$g-E<gt>write>.

=item $g->write_file ($path, $content, $size);

This call creates a file called C<path>.  The contents of the
file is the string C<content> (which can contain any 8 bit data),
with length C<size>.

As a special case, if C<size> is C<0>
then the length is calculated using C<strlen> (so in this case
the content cannot contain embedded ASCII NULs).

I<NB.> Owing to a bug, writing content containing ASCII NUL
characters does I<not> work, even if the length is specified.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

I<This function is deprecated.>
In new code, use the L</write> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->xfs_admin ($device [, extunwritten => $extunwritten] [, imgfile => $imgfile] [, v2log => $v2log] [, projid32bit => $projid32bit] [, lazycounter => $lazycounter] [, label => $label] [, uuid => $uuid]);

Change the parameters of the XFS filesystem on C<device>.

Devices that are mounted cannot be modified.
Administrators must unmount filesystems before this call
can modify parameters.

Some of the parameters of a mounted filesystem can be examined
and modified using the C<$g-E<gt>xfs_info> and
C<$g-E<gt>xfs_growfs> calls.

Beginning with XFS version 5, it is no longer possible to modify
the lazy-counters setting (ie. C<lazycounter> parameter has no effect).

This function depends on the feature C<xfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->xfs_growfs ($path [, datasec => $datasec] [, logsec => $logsec] [, rtsec => $rtsec] [, datasize => $datasize] [, logsize => $logsize] [, rtsize => $rtsize] [, rtextsize => $rtextsize] [, maxpct => $maxpct]);

Grow the XFS filesystem mounted at C<path>.

The returned struct contains geometry information.  Missing
fields are returned as C<-1> (for numeric fields) or empty
string.

This function depends on the feature C<xfs>.  See also
C<$g-E<gt>feature-available>.

=item %info = $g->xfs_info ($pathordevice);

C<pathordevice> is a mounted XFS filesystem or a device containing
an XFS filesystem.  This command returns the geometry of the filesystem.

The returned struct contains geometry information.  Missing
fields are returned as C<-1> (for numeric fields) or empty
string.

This function depends on the feature C<xfs>.  See also
C<$g-E<gt>feature-available>.

=item $status = $g->xfs_repair ($device [, forcelogzero => $forcelogzero] [, nomodify => $nomodify] [, noprefetch => $noprefetch] [, forcegeometry => $forcegeometry] [, maxmem => $maxmem] [, ihashsize => $ihashsize] [, bhashsize => $bhashsize] [, agstride => $agstride] [, logdev => $logdev] [, rtdev => $rtdev]);

Repair corrupt or damaged XFS filesystem on C<device>.

The filesystem is specified using the C<device> argument which should be
the device name of the disk partition or volume containing the filesystem.
If given the name of a block device, C<xfs_repair> will attempt to find
the raw device associated with the specified block device and will use
the raw device instead.

Regardless, the filesystem to be repaired must be unmounted, otherwise,
the resulting filesystem may be inconsistent or corrupt.

The returned status indicates whether filesystem corruption was
detected (returns C<1>) or was not detected (returns C<0>).

This function depends on the feature C<xfs>.  See also
C<$g-E<gt>feature-available>.

=item $g->yara_destroy ();

Destroy previously loaded Yara rules in order to free libguestfs resources.

This function depends on the feature C<libyara>.  See also
C<$g-E<gt>feature-available>.

=item $g->yara_load ($filename);

Upload a set of Yara rules from local file F<filename>.

Yara rules allow to categorize files based on textual or binary patterns
within their content.
See C<$g-E<gt>yara_scan> to see how to scan files with the loaded rules.

Rules can be in binary format, as when compiled with yarac command, or
in source code format. In the latter case, the rules will be first
compiled and then loaded.

Rules in source code format cannot include external files. In such cases,
it is recommended to compile them first.

Previously loaded rules will be destroyed.

This function depends on the feature C<libyara>.  See also
C<$g-E<gt>feature-available>.

=item @detections = $g->yara_scan ($path);

Scan a file with the previously loaded Yara rules.

For each matching rule, a C<yara_detection> structure is returned.

The C<yara_detection> structure contains the following fields.

=over 4

=item C<yara_name>

Path of the file matching a Yara rule.

=item C<yara_rule>

Identifier of the Yara rule which matched against the given file.

=back

This function depends on the feature C<libyara>.  See also
C<$g-E<gt>feature-available>.

=item @lines = $g->zegrep ($regex, $path);

This calls the external C<zegrep> program and returns the
matching lines.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

I<This function is deprecated.>
In new code, use the L</grep> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item @lines = $g->zegrepi ($regex, $path);

This calls the external C<zegrep -i> program and returns the
matching lines.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

I<This function is deprecated.>
In new code, use the L</grep> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $g->zero ($device);

This command writes zeroes over the first few blocks of C<device>.

How many blocks are zeroed isn't specified (but it’s I<not> enough
to securely wipe the device).  It should be sufficient to remove
any partition tables, filesystem superblocks and so on.

If blocks are already zero, then this command avoids writing
zeroes.  This prevents the underlying device from becoming non-sparse
or growing unnecessarily.

See also: C<$g-E<gt>zero_device>, C<$g-E<gt>scrub_device>,
C<$g-E<gt>is_zero_device>

=item $g->zero_device ($device);

This command writes zeroes over the entire C<device>.  Compare
with C<$g-E<gt>zero> which just zeroes the first few blocks of
a device.

If blocks are already zero, then this command avoids writing
zeroes.  This prevents the underlying device from becoming non-sparse
or growing unnecessarily.

=item $g->zero_free_space ($directory);

Zero the free space in the filesystem mounted on F<directory>.
The filesystem must be mounted read-write.

The filesystem contents are not affected, but any free space
in the filesystem is freed.

Free space is not "trimmed".  You may want to call
C<$g-E<gt>fstrim> either as an alternative to this,
or after calling this, depending on your requirements.

=item $g->zerofree ($device);

This runs the I<zerofree> program on C<device>.  This program
claims to zero unused inodes and disk blocks on an ext2/3
filesystem, thus making it possible to compress the filesystem
more effectively.

You should B<not> run this program if the filesystem is
mounted.

It is possible that using this program can damage the filesystem
or data on the filesystem.

This function depends on the feature C<zerofree>.  See also
C<$g-E<gt>feature-available>.

=item @lines = $g->zfgrep ($pattern, $path);

This calls the external C<zfgrep> program and returns the
matching lines.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

I<This function is deprecated.>
In new code, use the L</grep> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item @lines = $g->zfgrepi ($pattern, $path);

This calls the external C<zfgrep -i> program and returns the
matching lines.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

I<This function is deprecated.>
In new code, use the L</grep> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item $description = $g->zfile ($meth, $path);

This command runs L<file(1)> after first decompressing C<path>
using C<meth>.

C<meth> must be one of C<gzip>, C<compress> or C<bzip2>.

Since 1.0.63, use C<$g-E<gt>file> instead which can now
process compressed files.

I<This function is deprecated.>
In new code, use the L</file> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item @lines = $g->zgrep ($regex, $path);

This calls the external L<zgrep(1)> program and returns the
matching lines.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

I<This function is deprecated.>
In new code, use the L</grep> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=item @lines = $g->zgrepi ($regex, $path);

This calls the external C<zgrep -i> program and returns the
matching lines.

Because of the message protocol, there is a transfer limit
of somewhere between 2MB and 4MB.  See L<guestfs(3)/PROTOCOL LIMITS>.

I<This function is deprecated.>
In new code, use the L</grep> call instead.

Deprecated functions will not be removed from the API, but the
fact that they are deprecated indicates that there are problems
with correct use of these functions.

=cut

1;

=back

=head1 AVAILABILITY

From time to time we add new libguestfs APIs.  Also some libguestfs
APIs won't be available in all builds of libguestfs (the Fedora
build is full-featured, but other builds may disable features).
How do you test whether the APIs that your Perl program needs are
available in the version of C<Sys::Guestfs> that you are using?

To test if a particular function is available in the C<Sys::Guestfs>
class, use the ordinary Perl UNIVERSAL method C<can(METHOD)>
(see L<perlobj(1)>).  For example:

 use Sys::Guestfs;
 if (defined (Sys::Guestfs->can ("set_verbose"))) {
   print "\$g->set_verbose is available\n";
 }

To test if particular features are supported by the current
build, use the L</feature_available> method like the example below.  Note
that the appliance must be launched first.

 $g->feature_available ( ["augeas"] );

For further discussion on this topic, refer to
L<guestfs(3)/AVAILABILITY>.

=head1 STORING DATA IN THE HANDLE

The handle returned from L</new> is a hash reference.  The hash
normally contains some elements:

 {
   _g => [private data used by libguestfs],
   _flags => [flags provided when creating the handle]
 }

Callers can add other elements to this hash to store data for their own
purposes.  The data lasts for the lifetime of the handle.

Any fields whose names begin with an underscore are reserved
for private use by libguestfs.  We may add more in future.

It is recommended that callers prefix the name of their field(s)
with some unique string, to avoid conflicts with other users.

=head1 COPYRIGHT

Copyright (C) 2009-2023 Red Hat Inc.

=head1 LICENSE

Please see the file COPYING.LIB for the full license.

=head1 SEE ALSO

L<guestfs(3)>,
L<guestfish(1)>,
L<http://libguestfs.org>.

=cut
