/**
 * NavigationBars.kt
 * Filo
 *
 * Material 3 navigation bars for Filo Android app
 * Equivalent to iOS glass-effect navigation bars
 */

package com.filo.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.*
import androidx.compose.material.icons.outlined.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

// Filo brand colors
object FiloColors {
    val Primary = Color(0xFF22A0FB)
    val Surface = Color(0xFFF5F5F5)
    val OnSurface = Color(0xFF000000)
    val SurfaceContainer = Color(0xFFF0F0F0)
    val Divider = Color(0x0D000000) // 5% black
}

// MARK: - Surface Tonal Button (Material 3 equivalent of glass)

@Composable
fun FiloIconButton(
    icon: ImageVector,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    contentDescription: String? = null
) {
    Surface(
        onClick = onClick,
        modifier = modifier.size(42.dp),
        shape = CircleShape,
        color = FiloColors.SurfaceContainer,
        tonalElevation = 1.dp
    ) {
        Box(contentAlignment = Alignment.Center) {
            Icon(
                imageVector = icon,
                contentDescription = contentDescription,
                modifier = Modifier.size(20.dp),
                tint = FiloColors.OnSurface
            )
        }
    }
}

@Composable
fun FiloSendButton(
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Surface(
        onClick = onClick,
        modifier = modifier.size(24.dp),
        shape = CircleShape,
        color = FiloColors.Primary
    ) {
        Box(contentAlignment = Alignment.Center) {
            Icon(
                imageVector = Icons.Default.ArrowUpward,
                contentDescription = "Send",
                modifier = Modifier.size(14.dp),
                tint = Color.White
            )
        }
    }
}

// MARK: - Action Pill (Material 3 equivalent of glass pill)

@Composable
fun ActionPill(
    modifier: Modifier = Modifier,
    content: @Composable RowScope.() -> Unit
) {
    Surface(
        modifier = modifier.height(42.dp),
        shape = RoundedCornerShape(21.dp),
        color = FiloColors.SurfaceContainer,
        tonalElevation = 1.dp
    ) {
        Row(
            modifier = Modifier.padding(horizontal = 16.dp),
            horizontalArrangement = Arrangement.spacedBy(20.dp),
            verticalAlignment = Alignment.CenterVertically,
            content = content
        )
    }
}

// MARK: - Read Email Navigation

@Composable
fun ReadEmailNavigation(
    onBack: () -> Unit,
    onArchive: () -> Unit = {},
    onShare: () -> Unit = {},
    onLabel: () -> Unit = {},
    onMore: () -> Unit = {},
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .height(50.dp)
            .padding(horizontal = 20.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        FiloIconButton(
            icon = Icons.AutoMirrored.Filled.ArrowBack,
            onClick = onBack,
            contentDescription = "Back"
        )
        
        ActionPill {
            IconButton(onClick = onArchive, modifier = Modifier.size(40.dp)) {
                Icon(
                    Icons.Outlined.Archive,
                    contentDescription = "Archive",
                    modifier = Modifier.size(20.dp)
                )
            }
            IconButton(onClick = onShare, modifier = Modifier.size(40.dp)) {
                Icon(
                    Icons.Default.Share,
                    contentDescription = "Share",
                    modifier = Modifier.size(20.dp)
                )
            }
            IconButton(onClick = onLabel, modifier = Modifier.size(40.dp)) {
                Icon(
                    Icons.Outlined.Label,
                    contentDescription = "Label",
                    modifier = Modifier.size(20.dp)
                )
            }
        }
        
        FiloIconButton(
            icon = Icons.Default.MoreHoriz,
            onClick = onMore,
            contentDescription = "More"
        )
    }
}

// MARK: - Select Email Navigation

@Composable
fun SelectEmailNavigation(
    selectedCount: Int,
    onBack: () -> Unit,
    onArchive: () -> Unit = {},
    onShare: () -> Unit = {},
    onLabel: () -> Unit = {},
    onMarkRead: () -> Unit = {},
    onMore: () -> Unit = {},
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .height(52.dp)
            .padding(horizontal = 20.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Row(
            horizontalArrangement = Arrangement.spacedBy(4.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            FiloIconButton(
                icon = Icons.AutoMirrored.Filled.ArrowBack,
                onClick = onBack,
                contentDescription = "Back"
            )
            Text(
                text = "$selectedCount",
                fontSize = 15.sp,
                fontWeight = FontWeight.Medium,
                color = FiloColors.OnSurface
            )
        }
        
        ActionPill {
            IconButton(onClick = onArchive, modifier = Modifier.size(36.dp)) {
                Icon(
                    Icons.Outlined.Archive,
                    contentDescription = "Archive",
                    modifier = Modifier.size(20.dp)
                )
            }
            IconButton(onClick = onShare, modifier = Modifier.size(36.dp)) {
                Icon(
                    Icons.Default.Share,
                    contentDescription = "Share",
                    modifier = Modifier.size(20.dp)
                )
            }
            IconButton(onClick = onLabel, modifier = Modifier.size(36.dp)) {
                Icon(
                    Icons.Outlined.Label,
                    contentDescription = "Label",
                    modifier = Modifier.size(20.dp)
                )
            }
            IconButton(onClick = onMarkRead, modifier = Modifier.size(36.dp)) {
                Icon(
                    Icons.Outlined.Email,
                    contentDescription = "Mark as read",
                    modifier = Modifier.size(20.dp)
                )
            }
        }
        
        FiloIconButton(
            icon = Icons.Default.MoreHoriz,
            onClick = onMore,
            contentDescription = "More"
        )
    }
}

// MARK: - Compose Navigation

@Composable
fun ComposeNavigation(
    onClose: () -> Unit,
    onAttach: () -> Unit = {},
    onSend: () -> Unit,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .height(52.dp)
            .padding(horizontal = 20.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        FiloIconButton(
            icon = Icons.Default.Close,
            onClick = onClose,
            contentDescription = "Close"
        )
        
        ActionPill {
            IconButton(onClick = onAttach, modifier = Modifier.size(40.dp)) {
                Icon(
                    Icons.Default.AttachFile,
                    contentDescription = "Attach",
                    modifier = Modifier.size(20.dp)
                )
            }
            FiloSendButton(onClick = onSend)
        }
    }
}

// MARK: - Subpage Navigation

@Composable
fun SubpageNavigation(
    title: String,
    onBack: () -> Unit,
    modifier: Modifier = Modifier
) {
    Column(modifier = modifier.fillMaxWidth()) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .height(52.dp)
                .padding(horizontal = 20.dp),
            horizontalArrangement = Arrangement.spacedBy(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            FiloIconButton(
                icon = Icons.AutoMirrored.Filled.ArrowBack,
                onClick = onBack,
                contentDescription = "Back"
            )
            
            Text(
                text = title,
                fontSize = 17.sp,
                fontWeight = FontWeight.Bold,
                color = FiloColors.OnSurface,
                modifier = Modifier.weight(1f)
            )
            
            // Invisible spacer for balance
            Spacer(modifier = Modifier.size(42.dp))
        }
        
        HorizontalDivider(
            color = FiloColors.Divider,
            thickness = 1.dp
        )
    }
}

// MARK: - Previews

@Preview(showBackground = true, backgroundColor = 0xFFF5F5F5)
@Composable
private fun ReadEmailNavigationPreview() {
    ReadEmailNavigation(onBack = {})
}

@Preview(showBackground = true, backgroundColor = 0xFFF5F5F5)
@Composable
private fun SelectEmailNavigationPreview() {
    SelectEmailNavigation(selectedCount = 3, onBack = {})
}

@Preview(showBackground = true, backgroundColor = 0xFFF5F5F5)
@Composable
private fun ComposeNavigationPreview() {
    ComposeNavigation(onClose = {}, onSend = {})
}

@Preview(showBackground = true, backgroundColor = 0xFFFFFFFF)
@Composable
private fun SubpageNavigationPreview() {
    SubpageNavigation(title = "Settings", onBack = {})
}
