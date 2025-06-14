/* libguestfs generated file
 * WARNING: THIS FILE IS GENERATED FROM THE FOLLOWING FILES:
 *          generator/gobject.ml
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

#include <config.h>

#include "guestfs-gobject.h"

/**
 * SECTION:optargs-compress_device_out
 * @short_description: An object encapsulating optional arguments for guestfs_session_compress_device_out
 * @include: guestfs-gobject.h
 *
 An object encapsulating optional arguments for guestfs_session_compress_device_out
 */

#include <string.h>

struct _GuestfsCompressDeviceOutPrivate {
  gint level;
};

G_DEFINE_TYPE_WITH_CODE (GuestfsCompressDeviceOut, guestfs_compress_device_out, G_TYPE_OBJECT,
                         G_ADD_PRIVATE (GuestfsCompressDeviceOut));

enum {
  PROP_GUESTFS_COMPRESS_DEVICE_OUT_PROP0,
  PROP_GUESTFS_COMPRESS_DEVICE_OUT_LEVEL
};

static void
guestfs_compress_device_out_set_property(GObject *object, guint property_id, const GValue *value, GParamSpec *pspec)
{
  GuestfsCompressDeviceOut *self = GUESTFS_COMPRESS_DEVICE_OUT (object);
  GuestfsCompressDeviceOutPrivate *priv = self->priv;

  switch (property_id) {
    case PROP_GUESTFS_COMPRESS_DEVICE_OUT_LEVEL:
      priv->level = g_value_get_int (value);
      break;

    default:
      /* Invalid property */
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, property_id, pspec);
  }
}

static void
guestfs_compress_device_out_get_property(GObject *object, guint property_id, GValue *value, GParamSpec *pspec)
{
  GuestfsCompressDeviceOut *self = GUESTFS_COMPRESS_DEVICE_OUT (object);
  GuestfsCompressDeviceOutPrivate *priv = self->priv;

  switch (property_id) {
    case PROP_GUESTFS_COMPRESS_DEVICE_OUT_LEVEL:
      g_value_set_int (value, priv->level);
      break;

    default:
      /* Invalid property */
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, property_id, pspec);
  }
}

static void
guestfs_compress_device_out_finalize (GObject *object)
{
  G_OBJECT_CLASS (guestfs_compress_device_out_parent_class)->finalize (object);
}

static void
guestfs_compress_device_out_class_init (GuestfsCompressDeviceOutClass *klass)
{
  GObjectClass *object_class = G_OBJECT_CLASS (klass);
  object_class->set_property = guestfs_compress_device_out_set_property;
  object_class->get_property = guestfs_compress_device_out_get_property;

  /**
   * GuestfsCompressDeviceOut:level:
   *
   * A 32-bit integer.
   */
  g_object_class_install_property (
    object_class,
    PROP_GUESTFS_COMPRESS_DEVICE_OUT_LEVEL,
    g_param_spec_int (
      "level",
      "level",
      "A 32-bit integer.",
      G_MININT32, G_MAXINT32, -1,
      G_PARAM_CONSTRUCT | G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS
    )
  );

  object_class->finalize = guestfs_compress_device_out_finalize;
}

static void
guestfs_compress_device_out_init (GuestfsCompressDeviceOut *o)
{
  o->priv = guestfs_compress_device_out_get_instance_private (o);
  /* XXX: Find out if gobject already zeroes private structs */
  memset (o->priv, 0, sizeof (GuestfsCompressDeviceOutPrivate));
}

/**
 * guestfs_compress_device_out_new:
 *
 * Create a new GuestfsCompressDeviceOut object
 *
 * Returns: (transfer full): a new GuestfsCompressDeviceOut object
 */
GuestfsCompressDeviceOut *
guestfs_compress_device_out_new (void)
{
  return GUESTFS_COMPRESS_DEVICE_OUT (g_object_new (GUESTFS_TYPE_COMPRESS_DEVICE_OUT, NULL));
}
